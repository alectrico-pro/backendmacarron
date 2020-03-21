#Destruye un reader, equivale a cerrar la cuenta en un dispositivo
class DestroyReader
  prepend SimpleCommand

  def initialize( rid)
    @rid = rid
  end

  def call
    reader
  end

  private

  attr_accessor :rid

  def reader
    reader = Reader.find_by(:rid => rid)
    reader.destroy if reader
    return true
  end
end
