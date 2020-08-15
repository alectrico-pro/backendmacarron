class RemoteVerifyMacarron
  include Linea
  include HTTParty
  base_uri CFG[:autorizador_alectrica_url.to_s]

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
    @options = { query: { macarron: @macarron } }
    response = self.class.get('/verify_macarron', @options )

    if response and response.response.class == ::Net::HTTPOK and not response.parsed_response["resultado"].nil?
      @resultado = response.parsed_response["resultado"]
    else
      throw :error_verificando_macarron
    end

  end


end

