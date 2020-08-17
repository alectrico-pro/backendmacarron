require 'resolv'

class ApplicationController < ActionController::API

  #Response y ExceptionHandler se activa un llamado raise
  include Response
  include NotOriginAllowed
  include NotAuthTokenPresent
  include MacarronAusente
  include RequestNotAuthorized
  include ExceptionHandler
  include NotReader  
  include NotReaderId
  include NotClientId
  include InvalidCredentials
  include Linea

  before_action :authenticate_request
  before_action :cors
 
  attr_reader :current_reader

  helper_method :current_reader, :reader_signed_in? #Se usa en las vistas, json_builder

  private

    def authenticate_and_authorize #autenticacion usando autorizacion server

      autorizacion = ::AuthorizeApiRequestByParams.new(params)
      resultado = autorizacion.call
      decoded_token = resultado.send(:decoded_auth_token)
      decoded_reader = resultado.send(:reader)
      linea.info "Reader Decodificado #{decoded_token}"
      linea.info "Token Decodificado #{decoded_reader}"

      verificador = ::RemoteVerifyMacarron.new( params[:macarron_de_autorizacion.to_s] )
      resultado_del_verificador = verificador.get_result
      #Se obtiene un token de autorizacion en el Authorization Server, ese token se llama Access Token o Access Key. Se decodifica para verificar que es un token generado por el Authorización Server.  
      #Una vez decodificado se verifica que el origen coincida con la dirección del Authorization Server y luego ser verifica que no se hay expirado.
      #Los tokens que expiran implican un logout. El usuario debe hacer login nuevamente para obtener otro otro token. Tambíén puede usarse de otra forma. Qu el cliente reciba un token de inscripción que sirva para obtener el AccessKey.
      #access_key = AccessKey.new.get #El access key debe asignado en el login y guardado en el frontend o en este backend.
      #linea.info "Access Key es #{access_key}"

      #decoded_token = JsonWebToken.decode( access_key )
      #linea.info "Decoded Token #{decoded_token}"

      #origen = decoded_token["contenido"]["origen"]
      #linea.info "Origen es #{origen}"

#Primero se huelen el culo los backends
      expira = decoded_token["exp"]
      #if expira.to_i > Time.now.to_i
      #  throw "Token Expirado"
      #end
      
      linea.info "Resultado del Verificador #{resultado_del_verificador}"
      unless resultado_del_verificador
        throw "No Autorizado por AS"
      end
    end

    def authenticate_request
      linea.info "Authenticate Request Sin Chequeo de Macarrón"
    
      unless params[:auth_token]  
        raise NotAuthTokenPresent
        return
      end

      unless Reader.count > 0
        raise NotReader
        return
      end
      #current_user = AuthorizeApiRequest.call(request.headers).result
      #@current_user = AuthorizeApiRequestByParams.call(params).result
      @current_reader = AuthorizeApiRequestByParams.call(params).result

     # @current_circuito = AuthorizeApiRequestByParams.new(params).circuito


      unless @current_reader
        raise NotReader 
        return
      end

      unless @current_reader
        raise RequestNotAuthorized
        return
      end
    end

    def reader_signed_in?
      !!@current_reader
    end

    def allow_credentials
       response.headers['Access-Control-Allow-Credentials'] = true
    end

    def cors
      linea.info "Cors"
      #" https://github.com/ampproject/amphtml/blob/master/spec/amp-cors-requests.md"
      #blacklisting origin
      # @origen #deben coincidir con los origenes especificados en config/application.rb
      @origen = params[:__amp_source_origin] || params[":__amp_source_origin"]
      linea.error "No se ingresó el parámetro :__amp_source_origin" unless @origen
      header_origin = request.headers['Origin']
      raise NotOriginAllowed unless header_origin == @origen
      if URLS_PERMITIDAS
        header_origin = request.headers['Origin']
        #linea.info "dominios permitidos #{URLS_PERMITIDAS.inspect}"
        linea.info "Origen es #{request.headers['Origin']}"
        unless URLS_PERMITIDAS and @origen and @origen.in?( URLS_PERMITIDAS )
          linea.error "#{@origen} no está en la lista permitida"
          raise NotOriginAllowed
          return
        end
      else
        linea.info "No se han ingresado los micro servicios permitidos como variable de ambiente de heroku"
        raise NotOriginAllowed
        return
      end
      if
        response.headers['AMP-Access-Control-Allow-Source-Origin'] = @origen
        response.headers['Access-Control-Allow-Origin'] = @origen
        response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'
        linea.info "El origen coincide con el header"
      else
        if request.headers['AMP-Same-Origin']
          linea.info "Es Amp-Same-Orgin, adelante"
          #Todo bien, puede proseguir
        else
          linea.error "#{@origen} no permitido"
          raise NotOriginAllowed
          return
        end
      end

    end

end
