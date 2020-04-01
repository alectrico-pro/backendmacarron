#Crea un token para cada reader, lo uso para guardar la primera versión de los circuitos. Pero luego deberé usar macarrones nuevos o frescos para ir presentando el avance del diseño
class LoginReader
  prepend SimpleCommand

  def initialize(rid)
    @rid = rid
  end

  def call
#+ JsonWebToken.encode( reader: reader.as_json(:include => :user)) if reader
    reader
  end

  private

  attr_accessor :rid

  def reader
    Reader.find_by_rid(rid).try(:login)
  end
end
