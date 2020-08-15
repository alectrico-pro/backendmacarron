#Crea un token para cada reader, lo uso para guardar la primera versión de los circuitos. Pero luego deberé usar macarrones nuevos o frescos para ir presentando el avance del diseño
class LoginReader
  prepend SimpleCommand

  def initialize(rid)
    @rid = rid
  end

  def call
#+ JsonWebToken.encode( reader: reader.as_json(:include => :user)) if reader
    access_key = AccessKey.new(@rid).get #Este es el token de acceso, esto reemplaza al método antiguio en el que se guardaba el estado en la base de datos.
    #Por ejemplor def reader busca al user en la base de datos y hace que el login se anote.. No existe estado de login ahora, cada vez que la autenticación del token de acceso sea exitosa, eso se considerará logado.
    #eader
  end

  private

  attr_accessor :rid, :reader

  def reader
    @reader = Reader.find_by_rid(rid)
    @reader.try(:login)
    @reader
  end
end
