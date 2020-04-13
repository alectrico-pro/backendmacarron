#Crea un token para cada reader de amp-pages. Los readers pueden tener un usuario común que se denominan user. También está codificado en el token
class AuthenticateReader #Lo uso como before action en el controlador authentication
  include ::Linea
  include InvalidCredentials
  prepend SimpleCommand
 
  def initialize(rid)
    @rid = rid
  end

  def call 
   if reader
     linea.info "Hay reader"
     JsonWebToken.encode( reader: reader.as_json(:include => :user )) 
   else
     linea.error "No Hay reader"
     raise InvalidCredentials
     false
   end
  end

  private
  attr_accessor :rid, :reader

  def reader
    Reader.find_by(:rid => @rid) 
  end

end
