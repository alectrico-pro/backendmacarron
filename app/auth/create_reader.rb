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
    Reader.find_or_create_by(:rid => rid)
  end
end
