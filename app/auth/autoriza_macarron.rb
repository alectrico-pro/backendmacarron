#Se crea un macarrón para indicar que el usuario está logado en el backend. Ya lo esa en la página amp-pages que usa el backend de google
class AutorizaMacarron

  include ::Linea

  include InvalidCredentials
  prepend SimpleCommand

  def initialize(rid)
    @rid = rid
  end

  def call 
    macarron = Macarron.new( location: 'http://backend.alectrica.cl', identifier: 'w', key: ENV['SECRET_KEY_BASE'] ) if reader
    macarron.add_first_party_caveat('LoggedIn = true')
    macarron.serialize if reader
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
    raise InvalidCredentials
  end

end
