class AccessKey #Autorization Server
#Llama a un servidor de autorizaciones, para que obtener un token de acceso a este backend

  include HTTParty
  include Linea

  base_uri 'autorizador.herokuapp.com'

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
    response = self.class.get("/create_access_token?rid=#{@rid}")
    if response.response.class == ::Net::HTTPOK and not response.parsed_response["access_token"].nil?
      @key = response.parsed_response["access_token"]
    else
      linea.error "Error Requesting Access Token " 
      throw :error_requesting_access_token
    end

  end


end

