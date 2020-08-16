class AccessKey #Autorization Server
#Llama a un servidor de autorizaciones, para que obtener un token de acceso a este backend

  include HTTParty
  include Linea

  base_uri CFG[:autorizador_alectrica_url.to_s]

  def initialize( rid )
    @rid = rid
  end

  def get
    catch :error_requesting_access_token do
      get_key
    end
  end

  public

  def get_key
    begin
      response = self.class.get("/create_access_token?rid=#{@rid}")
    rescue StandardError => e
      linea.error e.inspect
    end
    if response and response.response.class == ::Net::HTTPOK and not response.parsed_response["access_token"].nil?
      @key = response.parsed_response["access_token"]
    else
      linea.error "Error Requesting Access Token " 
      linea.error response.inspect if response
      throw :error_requesting_access_token
    end

  end


end

