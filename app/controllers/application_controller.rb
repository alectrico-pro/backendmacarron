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

  def authenticate_request
    linea.info "Authenticate Request"
  
    unless params[:macarron_de_autorizacion]
      raise MacarronAusente
      return
    end

    unless params[:auth_token]  
      raise NotAuthTokenPresent
      return
    end

    unless Reader.count > 0
      raise NotReader
      return
    end
    #current_user = AuthorizeApiRequest.call(request.headers).result
    @current_user = AuthorizeApiRequestByParams.call(params).result
   # @current_circuito = AuthorizeApiRequestByParams.new(params).circuito


    unless @current_reader
      raise InvalidToken 
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

    if URLS_PERMITIDAS

      linea.info "dominios permitidos #{URLS_PERMITIDAS.inspect}"
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
