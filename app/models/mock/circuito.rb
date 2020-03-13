module Mock

  class Circuito 
    attr_accessor :largo, :max_spur, :grupo, :tipo_circuito, :cargas
    def initialize(largo, max_spur, grupo, tipo_circuito )
      @largo         = largo
      @max_spur      = max_spur
      @grupo         = grupo
      @tipo_circuito = tipo_circuito
      @cargas = []
    end
    def errors
    end
  end
end

