class RemoteVerifyMacarron
  include Linea
  include HTTParty
  base_uri C.autorizador_alectrica_url

  def initialize macarron
    @macarron = macarron
  end

  def get
#    catch :error_verificando_macarron do
      get_result
#    end
  end

  public

  def get_result
    linea.info "En get_result de RemoteVerifyMacarron"
    @options = { query: { macarron: @macarron } }
    response = self.class.get('/verify_macarron', @options )
    linea.info "Respuesta de la verificación es: #{response.inspect}"

    if response and response.response.class == ::Net::HTTPOK and not response.parsed_response["resultado"].nil?
      @resultado = response.parsed_response["resultado"]
    else
      throw :error_verificando_macarron
    end

  end


end

