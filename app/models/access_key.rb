class AccessKey #Autorization Server

  include HTTParty
  include Linea

  base_uri 'autoriza.herokuapp.com'

  def initialize( rid )
    @rid = rid
    linea.info @rid
  end

  def get
    catch :error_requesting_access_token do
      linea.info @rid
      get_key
    end
  end

  public

  def get_key
    linea.info @rid
    response = self.class.get("/create_access_token?rid=#{@rid}")
    if response.response.class == ::Net::HTTPOK and not response.parsed_response["access_token"].nil?
      @key = response.parsed_response["access_token"]
    else
      throw :error_requesting_access_token
    end

  end


end

