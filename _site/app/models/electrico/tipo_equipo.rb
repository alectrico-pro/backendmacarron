module Electrico
  class TipoEquipo < ElectricoBase
    #attr_accessible :i, :nombre, :p,:modelo,:genera_armonicos,:es_trifasico,:es_bifasico,:es_monofasico,:Ip,:tp,:tension, :fp, :curva, :eficiencia, :capacitancia_necesaria,:es_capacitor

    validates :i, :presence => true, numericality: true, allow_nil: false
    validates :tension, :presence => true, numericality: true , allow_nil: false
    validates :fp, :presence => true, numericality: true, allow_nil: false
    validates :p, :presence => true, numericality: { only_integer: true}, alow_nil: false
#    validates :modelo, :presence => true #Si no da error en los combobox de ediciones de cargas
    validates :capacitancia_necesaria, :presence => true, numericality:  true , allow_nil: false
    
    validates :nombre, :presence => true #Si es nil da error al gregar centros
    #validates :curva, :inclusion => { in: %w(B C E D MA Z), message: "Error en curva para este tipo de equipo"},:allow_nil => false



    has_many :cargas, inverse_of: :tipo_equipo, :class_name => "Electrico::Carga"
    validates_associated :cargas

#    has_many :cargas
#    has_and_belongs_to_many :circuitos

    before_save :x

    before_update :x

    scope :capacitor,-> { where(es_capacitor: true)}

    private


    def x

     #asume monofasico por defecto
     self.es_monofasico = true if self.es_monofasico.nil? and self.es_trifasico.nil?

     self.Ip = 0 unless !self.Ip.nil?
     self.tp = 0 unless !self.tp.nil?
     self.eficiencia=100 unless !self.eficiencia.nil?




     if self.es_trifasico
       self.i= self.p/(Math.sqrt(3) * self.tension * self.fp )
     elsif self.es_monofasico
       self.i = self.p / ( self.tension * self.fp)
     end

     #256
     if self.eficiencia>0
      e = (self.eficiencia) / 100 
      self.i = self.i / self.eficiencia * 100
     end

     if self.Ip > 0
      e = self.Ip / 100
      self.i = self.i + self.i*e
     end

     self.i=self.i.round(2 )
     if self.genera_armonicos

	  #funtes CC sin compensanción CFL
		    #pagina 47 curso legranda de evaluación de cortocircuitos
	     #        #indica cargas electrónicas PABX MyHIME
	     #              self.curva = "Z"
	     #                   end
	     #
       self.curva = "Z"
     else
       if  self.Ip> 1.5 
	#corrientes de partidias elevadas, para evitar disparos intempesitvos
       #trnasformadores y motores
       #cargas inductivas Motores jaula de ardilla,  inductivas
       #capactivias Bombas . industrial
	self.curva = "D"
       end

       if self.fp >= 0.95
	#Para intensidades débiles de cortorcuito 
	 #( grna longitudes grnades, 
	#y       #o decidi > 60m esto se calcula en otra parte. En el cálculo del circuito como tal.
	#indicda para cargas resistivas , calefacci´n ampolletas, pequeñops motores
	self.curva = "B"
       end

       #alumbrado, PC, Fluorescente, Lámpara de descarga, Halógena,motores pequeños
       if  self.fp < 0.95 && !(self.Ip > 1.5) && !(self.tp>0)
	self.curva = "C"
       end

     end

     if !self.fp.blank? && !self.fp.nil? && self.es_monofasico
       #raise "ol"
	self.capacitancia_necesaria = (1000000 * self.p*(Math.tan( Math.acos(self.fp))) / (2 * 3.1416 *  50 * self.tension*self.tension)).round(0)
	#http://iesmonre.educa.aragon.es/i+c/i+c0607/presentaciones/electrodomesticos/frigorificos.html
     end


     if !self.fp.blank? && !self.fp.nil? && self.es_trifasico
       #[3~http://www.tuveras.com/fdp/fdp.htm
       self.capacitancia_necesaria = (1000000 * self.p*(Math.tan( Math.acos(self.fp))) / (3 * 3.1416 *  50 * self.tension*self.tension) ).round(0)
       #en microfaradios
     end

     self.capacitancia_necesaria=self.capacitancia_necesaria.round(2)  

    end


  public

    def get_modelo
      @modelo = self.modelo
    end

    def get_nombre
      @nombre = self.nombre
    end

    def get_i
      @i = self.i
    end

    def get_tension
      raise self.nombre unless self.tension
      @tension = self.tension
    end

    def get_fp
      @fp = self.fp
    end

    def set_numero_polos
      if self.es_monofasico
	@numero_polos =1
      elsif self.es_trifasico
	@numero_polos =3
      else
	@numero_polos = 1
      end
    end

    def get_polos
      @numero_polos=  set_numero_polos if @numero_polos.nil?
      @numero_polos
    end

    def get_capacitancia
       @capacitancia = self.capacitancia_necesaria.round(2)
    end
   
    def get_curva
      @curva = self.curva
    end

    def get_ip
      @ip = self.Ip
    end

    def get_eficiencia
      @eficiencia = self.eficiencia
    end

    def get_armonicos
      @armonicos = self.genera_armonicos
    end

    def get_p
      @p = self.p
    end

    def get_capacitancia
      @capacitancia = self.capacitancia_necesaria
    end


    def get_n
      case get_curva
       when 'B'
	 @n = 5
       when 'C'
	 @n =  10
       when 'D'
	 @n = 20
       when 'Z'
	 @n=  3.6
       when 'MA'
	 @n= 14
      end
      @n
    end
  end
end
