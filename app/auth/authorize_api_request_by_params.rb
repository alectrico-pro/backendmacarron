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
    user
  end

  attr_reader :circuito

  def circuito
    circuito = Circuito.new
    circuito_decoded = decoded_auth_token['circuito']

    if circuito_decoded
      circuito = Circuito.new
      circuito.from_json( circuito_decoded[ 'circuito' ].to_json)
    end

    @circuito || circuito if circuito
    return @circuito if circuito
    raise ExceptionHandler::InvalidToken unless circuito

  end


  private

  attr_reader :user, :params

  def user
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

    if reader_decoded and reader_decoded['user'].present?
      user = User.new
      user.from_json(reader_decoded['user'].to_json) 
      reader.from_json( reader_decoded.except('user').to_json )
    end
#    reader.from_json(decoded_auth_token['reader'].to_json) if decoded_auth_token
  # cliente = Client.find_by(:clientID => @params[:clientId])
   #@user = cliente.reader.user
    @user ||= user if user
    return @user if user
    raise ExceptionHandler::InvalidToken unless user
    unless user
      @user || errors.add(:token, 'Token Inválido') && nil 
    end

  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode( http_params )    
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
