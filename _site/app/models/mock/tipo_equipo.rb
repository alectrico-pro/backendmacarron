class Mock::TipoEquipo
  attr_accessor :i, :tension, :fp, :p, :capacitancia_necesaria, :nombre, :curva, :cargas, :img, :id
  def initialize(id, nombre, img)
    @id = id
    @nombre = nombre
    @img = img
  end
end
