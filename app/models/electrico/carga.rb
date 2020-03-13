module Electrico
  class Carga < ElectricoBase
    #self.table_name_prefix = self.connection_config[:database] + "."
    #attr_accessible :tipo_equipo_id,:cargolizable_id, :cargolizable_type, :cantidae

  #  validates :cantidad, :presence => true,:alow_nil => false, numericality: { only_integer: true}
  #  belongs_to :cargolizable, polymorphic: true
   
    belongs_to :presupuesto, validate: true 
    belongs_to :circuito, validate: true
#    validates :circuito, presence: true

    belongs_to :tipo_equipo
    validates :tipo_equipo, presence: true 

    delegate :get_p, to: :tipo_equipo

    after_create :defaulty

    def defaulty
       self.cantidad ||= 1
    end
    
    def +(z)
      raise "No se puede usar una carga nil" unless z
      raise "Error, no se pueden sumar las cargas de equipos con diferentes voltajes" if self.get_tension != z.get_tension
      @i += z.get_i #Esta es una suma aritmética, que no comtemplael factor de potencia 
      @p += z.get_p 
      @fp = self.get_fp < z.get_fp ? self.get_fp : z.get_fp 
      return self
    end

    def get_circuito
      @circuito = Circuito.find_by_id(self.cargolizable_id)    
    end

    def set_equipo 
      @equipo = Electrico::TipoEquipo.find_by_id(self.tipo_equipo_id)
    end

    def get_equipo
      set_equipo if @equipo.nil?
      @equipo
    end

    def reset(tension)
      @i=0
      @p=0
      @tension=tension
    end

    def get_i
      unless @i
	@i = get_equipo.get_i * get_cantidad
	@i=@i.round(2)
      else
	@i=@i.round(2)
      end
    end

    def get_nombre
      @nombre = get_equipo.get_nombre
    end

    def get_tension
      raise "Carga no tiene especificado equipo #{self.nombre}" unless get_equipo
      @tension = get_equipo.get_tension 
    end

    def get_capacitancia_uf
      @capacitancia = get_equipo.get_capacitancia  
    end
    
    def get_polos
      @polos = get_equipo.get_polos
    end

    def get_modelo
      @modelo = get_equipo.get_modelo
    end

    def get_p
      unless @p
	@p = get_equipo.get_p
      else
	@p
      end
    end
    
    def get_cantidad
      @cantidad = self.cantidad
      @cantidad ||= 1
      @cantidad == 0 ? 1 : @cantidad 
    end

    def get_fp
      @fp = get_equipo.get_fp
    end

    def get_n
      @n = get_equipo.get_n
    end

    def get_curva
      @curva        = get_equipo.get_curva
    end

    def get_fpc
      @fpc = get_equipo.get_capacitancia
    end

  end
end
