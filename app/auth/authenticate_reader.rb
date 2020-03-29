#Crea un token para cada reader de amp-pages. Los readers pueden tener un usuario común que se denominana user. También está codificado en el token
class AuthenticateReader #Lo uso como before action en el controlador authentication
  include ::Estructura #Estructuras que reemplazan a ActiveRecord por ahora en este proyecto de transición
  include ::Linea

  include InvalidCredentials
  prepend SimpleCommand

  def initialize(rid)
    @rid = rid
  end

  def call 
   if reader
     JsonWebToken.encode(circuito: circuito.as_json, reader: reader.as_json(:include => :user )) 
   else
     false
   end
  end

  public 
  attr_accessor :email

  private
  attr_accessor :rid, :reader, :circuito

  def circuito
   circuito = ::Circuito.new
  end

  def reader
    Reader.find_by(:rid => @rid) 
    #eturn reader if reader
#    raise InvalidCredentials
  end

end
