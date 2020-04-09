class AccessKey #Autorization Server

  include HTTParty
  base_uri 'autoriza.herokuapp.com'

  def get
    catch :error_requesting_access_token do
      get_key
    end
  end

  public

  def get_key
    response = self.class.get("/create_access_token?reader=#{reader.as_json(:include => :user, :root => true)}")
    if response.response.class == ::Net::HTTPOK and not response.parsed_response["access_token"].nil?
      @key = response.parsed_response["access_token"]
    else
      throw :error_requesting_access_token
    end

  end


end

