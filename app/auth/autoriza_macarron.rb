class AutorizaMacarron

  include ::Linea

  include InvalidCredentials
  prepend SimpleCommand

  def initialize(rid)
    @rid = rid
  end

  def call 
    #Encripta circuito y reader, dentro de reader (a user) ) 
    #Un user puede tener varios readers (uno por cada device))
    macarron = Macarron.new( location: 'http://backend.alectrica.cl', identifier: 'w', key: ENV['SECRET_KEY_BASE'] ) if reader
    macarron.add_first_party_caveat('LoggedIn = false')
    macarron.serialize if reader
#    token = JsonWebToken.encode(circuito: circuito.as_json, reader: reader.as_json(:include => :user )) if reader
  #  decoded_token = JsonWebToken.decode(token)

  end


  public 
  attr_accessor :email

  private
  attr_accessor :rid, :reader, :circuito

  def circuito
   circuito = ::Circuito.new
  end

  def reader
    
    reader = Reader.find_by(:rid => @rid) 
    return reader if reader
    #ser = reader.user if reader
    #email = user.email if user and  user.valid?
    #eturn user if user #and user.valid?#&& user.authenticate(password)
    raise InvalidCredentials
    #rrors.add :reader_authentication, 'invalid credentials'
    #il
  end

end
