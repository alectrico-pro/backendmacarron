module Mock
  class Mock::TipoCircuito 
    attr_accessor :id, :letras, :nombre, :capacidad, :requiere_diferencial
    def initialize(id, letras, nombre, capacidad, requiere_diferencial)
      @id                   = id
      @letras               = letras
      @nombre               = nombre
      @capacidad            = capacidad
      @requiere_diferencial = requiere_diferencial
    end
  end
end
