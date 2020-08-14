#Crea un reader, equivale a cerrar la cuenta en un dispositivo
class CreateReader
  prepend SimpleCommand

  def initialize( rid, clientId )
    @rid      = rid
    @clientId = clientId
  end

  def call
    reader
  end

  private

  attr_accessor :rid

  def reader
    reader  = Reader.find_or_create_by(:rid => rid)
    cliente = Client.find_or_create_by(:reader_id => rid, :clientId => @clientId)
    if cliente.present?
      reader.update(:clientId => cliente.id)    
    end
    reader
  end
end
