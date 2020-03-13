module ControllerSpecHelper

  def token_generador( reader, circuito )
    if reader
      token = JsonWebToken.encode( circuito: circuito.as_json, reader: reader.as_json( :include => :user ) )       
      #decoded_token = JsonWebToken.decode(token)
      #raise decoded_token['circuito'].inspect
      return token
    end
#   JsonWebToken.encode(:reader => reader_id)
  end

  def valid_params(reader)
    { "auth_token" => token_generador( reader ) } 
  end

end
