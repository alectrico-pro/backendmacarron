module Mock
  class Mock::Carga
    attr_accessor :id, :tipo_equipo, :cantidad, :circuito
    def initialize( id, tipo_equipo, cantidad, circuito)
      @id          = id
      @tipo_equipo = tipo_equipo
      @cantidad    = cantidad
      @circuito    = circuito
    end
  end
end
