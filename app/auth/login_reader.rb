#Crea un token para cada reader, lo uso para guardar la primera versión de los circuitos. Pero luego deberé usar macarrones nuevos o frescos para ir presentando el avance del diseño
class LoginReader
  include Estructura
 # include InvalidCredentials
  prepend SimpleCommand

  def initialize(rid)
    @rid = rid
  end

  def call
    JsonWebToken.encode(circuito: circuito.as_json, reader: reader.as_json(:include => :user)) if reader
  end

  private

  attr_accessor :rid, :circuito

  def circuito
   circuito = ::Circuito.new
  end



  def reader
    reader = Reader.find_by_rid(rid)
    return reader if reader#&& user.authenticate(password)
#   raise InvalidCredentials
    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
