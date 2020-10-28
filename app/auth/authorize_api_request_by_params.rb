#usa el token jwt que viene en el header y el macarron que viene en un param para autorizar el request. El macarron tiene un caveats de LoggedIn al menos que debe coincidir con el sitema de autorización de amp-params. El que usa un backend en google que setea el logged

class AuthorizeApiRequestByParams
  include Estructura
  include Linea

  prepend SimpleCommand
  include NotAuthTokenPresent
  include MacarronAusente
  include NotReader
  include InvalidToken

  def initialize( params = {} )
    @params = params
  end

  def call
    reader
  end

  private

  attr_reader :reader, :params, :decoded_token


    def authenticate_as
      #Se obtiene un token de autorizacion en el Authorization Server, ese token se llama Access Token o Access Key. Se decodifica para verificar que es un token generado por el Authorización Server.  
      #Una vez decodificado se verifica que el origen coincida con la dirección del Authorization Server y luego ser verifica que no se hay expirado.
      #Los tokens que expiran implican un logout. El usuario debe hacer login nuevamente para obtener otro otro token. Tambíén puede usarse de otra forma. Qu el cliente reciba un token de inscripción que sirva para obtener el AccessKey.
      access_key = AccessKey.new.get #El access key debe asignado en el login y guardado en el frontend o en este backend.
      linea.info "Access Key es #{access_key}"

      decoded_token = JsonWebToken.decode( access_key )
      linea.info "Decoded Token #{decoded_token}"

      origen = decoded_token["contenido"]["origen"]
      linea.info "Origen es #{origen}"

      expira = decoded_token["exp"]
      if expira.to_i > Time.now.to_i
        throw "Token Expirado"
      end
      unless origen.match(CFG[:as.to_s] )
        throw "No Autorizado por AS"
      end
    end




  def reader
    linea.info "En AuthorizeApiRequestByParam"
    linea.info params.inspect
    if params["macarron_de_autorizacion"]
      linea.info "Existe macarron de autorizacion"
      macarron = params["macarron_de_autorizacion"]
      linea.info "Macarrón de autorizadón #{macarron}"
      resultado = RemoteVerifyMacarron.new( macarron )

      if resultado.get
        linea.info "Macarrón Verificado Ok Remotamente"
      else
        linea.error "Macarrón Verificado Fail Remotamente"
        #eturn false unless Rails.env.test?
        raise MacarronAusente
      end

    else        
      linea.error "Macarrón No pudo Ser Verificado En endpoint AS"
      raise InvalidToken
      raise MacarronAusente
    end

    decoded_token = decoded_auth_token
    
    linea.info "Analizando token decodificado"
    linea.info "Token es #{decoded_token}"
    if decoded_token.has_key?('rid')
      linea.info "Token Remoto"
      reader = Reader.find_by(:rid => decoded_token['rid'])
      linea.info "rid es #{decoded_token['rid']}"
      raise NotReader unless reader
    elsif decoded_token.has_key?('reader')
      linea.info "Token Local"
      reader = Reader.new
      reader_decoded = decoded_token['reader']
      reader.from_json( reader_decoded.except('user').to_json )
    else
      linea.info "Token invalido"
      raise InvalidToken
    end
    linea.info "Terminado el procesamiento  en reader"
    reader
  end

  def reader_v_1
    v = Macarron::Verifier.new()

    v.satisfy_exact('LoggedIn = true')

    macarron_serializado = params["macarron_de_autorizacion"]
    linea.info "Recuperando el Macarron serializado" 
    linea.info macarron_serializado

    macarron = Macarron.deserialize(macarron_serializado)
    linea.info "Deserializando el Macarron"
    verified = v.verify( macaroon: macarron, key: ENV['SECRET_KEY_BASE'] )

    linea.info "Macarrón Verificado" if verified
    linea.error "Macarrón Inválido" unless verified

    errors.add AuthorizeApiRequestByParams.to_s, 'macarrón inválido'

    raise ExceptionHandler::MacarronInvalido unless verified

    reader = Reader.new
    reader_decoded = decoded_auth_token['reader']
    reader.from_json( reader_decoded.except('user').to_json )

=begin
    if reader_decoded and reader_decoded['user'].present?
      user = User.new
      user.from_json(reader_decoded['user'].to_json) 
      reader.from_json( reader_decoded.except('user').to_json )
    end
=end
#    reader.from_json(decoded_auth_token['reader'].to_json) if decoded_auth_token
  # cliente = Client.find_by(:clientID => @params[:clientId])
   #@user = cliente.reader.user
=begin
    @user ||= user if user
    return @user if user
    raise ExceptionHandler::InvalidToken unless user
    unless user
      @user || errors.add(:token, 'Token Inválido') && nil 
    end
=end
  end

  def decoded_auth_token
    linea.info "Intentando decodificar el token"
    linea.info "params es #{http_params}"
    begin
      @decoded_auth_token ||= JsonWebToken.decode( http_params )    
    rescue StandardError => e
      linea.error "Error decodificando token #{e.inspect}"
      raise InvalidToken
    end
    raise InvalidToken unless @decoded_auth_token

    linea.info "Decoded Token #{@decoded_auth_token}"

    if @decoded_auth_token.has_key?("origen") and @decoded_auth_token["origen"] == "autoriza.herokuapp.com"
      begin
        linea.info "El token es remoto"
        origen = @decoded_auth_token["origen"]
        linea.info "Origen es #{origen}"

         expira = decoded_token["exp"]

         if expira.to_i > Time.now.to_i
           throw "Token Expirado"
         end

         unless origen.match("autoriza.herokuapp.com" )
           throw "No Autorizado por AS"
         end

      rescue
        linea.info @decoded_auth_token
        throw "Invalid Origen" unless origen
      end
    else
      linea.info "El token es local al backend"
    end

    @decoded_auth_token

  end

  def http_params
    if params[ 'auth_token' ].present?
      return params[ 'auth_token' ]
    else
      raise NotAuthTokenPresent
      return
#      errors.add(:token, 'Token Perdido')
    end
    unless Reader.count > 0
      raise NotReader
      return
    end
    nil
  end
end
