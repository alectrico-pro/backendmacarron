#encoding: UTF-8
#require_relative 'requerido'
include Electrico::ApplicationHelper
module Electrico

  module G
    def memoria
      Logging::Logger.new(self.class)
    end
  end

  class Circuito < ElectricoBase
    include G

   #Requerido.gestionar Esto se usaba en versiones anteriors de Rails para cargar las clases en producción. Ahora se usa eager load en producción por lo que deben agregarse las clases a la ruta de autoloading en application.rb

   def solo_un_circuito #en ambiente de test

     if Circuito.count > 1 and Rails.env.test?
       errors[:base] << "No se acepta más de dos circuitos"
     end
   end

   def no_puede_tener_mas_de_50_cargas
      if cargas.count > 50
	errors[:base] << "Se llegó al límite máximo. No se puede agregar nada más a este circuito."
	#raise cargas.count.to_s
	#no he podido hacerlo funcionar
      end
=begin 
      unless cargas.count > 0
	errors[:base] << "Debe especificarse una carga al menos, presion en el bon + para agregar cargas, elija la que más se aproxime"
      end
=end
    end

    before_destroy :borrar_nodos

    serialize :proteccionD1
    serialize :proteccionD2
    serialize :proteccionD3

#    attr_accessor :proteccionD1
#    attr_accessor :proteccionD2
    #attr_accessor :proteccionD3
    #attr_accessor :instalacion
    #serialize :instalacion


    validates :largo, presence: true
    validates :grupo, presence: true
    #validates :cargas, presence: true
#    validates :tipo_circuito, presence: true

    validate :no_puede_tener_mas_de_50_cargas
   # validate :solo_un_circuito

    belongs_to :presupuesto, :optional => true
    belongs_to :automatico,  :optional => true
    belongs_to :conductor,    :class_name => "::Electrico::Conductor", :optional => true
    belongs_to :tipo_circuito, :optional => true
    belongs_to :forro,        :class_name => "::Electrico::Forro", :optional => true
    belongs_to :canalizacion, :optional => true

    has_many :materiales,                           dependent: :delete_all
    has_many :materiales, as: :materializable,      dependent: :delete_all
    has_many :recintos,   as: :recintable,          dependent: :delete_all
    has_many :costos,     as: :costolizable,        dependent: :delete_all
#    has_many :cargas,     as: :cargolizable,        dependent: :delete_all
    has_many :cargas, inverse_of: :circuito, :class_name => "Electrico::Carga", dependent: :destroy

    accepts_nested_attributes_for :materiales, :allow_destroy => true
    accepts_nested_attributes_for :costos,     :allow_destroy => true
    accepts_nested_attributes_for :cargas,     :allow_destroy => true
    accepts_nested_attributes_for :recintos,   :allow_destroy => true

    scope :no_alimenta, -> {where("es_alimentador IS NULL")}
##   scope :no_vacios  , -> {cargas.any?}
#    def self.no_vacios
 #     cargas.count > 0
 #   end
    scope :alimentador, -> {where("es_alimentador IS true")}

    #before_save :calcula
    #before_validation :defaulties


    def borrar_nodos
      #Borrar todos los nodos cuando se acaben los circuitos
      if self.presupuesto.circuitos.count == 1
	#los nodos son agregados desde instalacion.rb de esta forma
   
	  #@D3         = select_D3("D3: "+ccto.nombre)#(@carga_equivalente_circuito)
	  # @linea      = Alimentador.new( ccto.get_conductor.get_iz, ccto.get_largo, ccto.get_conductor.seccion,ccto.get_no_conductores, ccto.get_conductor.seccion,ccto.get_no_conductores, ccto.get_conductor.seccion,ccto.get_no_conductores,'Linea'+ @circuito.id.to_s,ccto)
	
	la_instalacion = self.presupuesto.get_instalacion
	#la_instalacion.delete_by_nombre("D3: "+ self.nombre) if la_instalacion

	if la_instalacion
	  b3 = la_instalacion.find_by_nombre('B3: Barra General en Tablero') 
	  if b3 and b3.get_coleccion
	    b3.get_coleccion.each do |disyuntor|
	      b3.get_coleccion.delete(disyuntor) if disyuntor.id == self.id
	      b3.get_coleccion.compact!
	    end
	  end
	  la_instalacion.delete_by_nombre('Linea'+ self.id.to_s)
	 # la_instalacion.delete_by_nombre('D3:' + self.nombre.to_s)
	end	
	la_instalacion = nil
	self.presupuesto.set_instalacion( la_instalacion)
      end
    end

    def +(z)
      #  @carga_conectada    += z.carga_conectada
      @corriente_servicio += z.corriente_servicio
    end


    def initialize( options = {})

      super(options)
      #En environmente test, se el memo se debe inciar en spec_helper y no debe userse el circuito para guardar los datos => Memo.new(false)
      reset_memoria unless Rails.env.test?
      #(esto se hace para comenzar a escribir en el registro ActiveRecord de un circuito, la memoria de cálculo
=begin      
      $logger=Memo.new(self, true, "info") unless Rails.env.test?
      $logger.debug "Método initialize en models/circuito.rb"
      $logger.debug "El nombre de este circuito o alimentador es"
      $logger.debug self.nombre
      $logi = memoria
      $p = memoria
=end
=begin
      skq= 500 #Esta es una suposición de Legrand aunque hay tablas de los cursos
      str= 75 #Este dato se saca del Gis (En rodolfo Lenz 300)
      uo = 231 #Si hay un solo transformador la tension entre las fases debiera ser igual a la tensión de servicio. El ejemplo de Legranda hablaba de 400
      un = 231
      ucc= 4

      skq = self.presupuesto.skq
      str = self.presupuesto.str
      uo  = self.presupuesto.uo
      un  = self.presupuesto.un
      ucc = self.presupuesto.ucc
=end
      self.no_fases = 1 unless self.no_fases
      #instalacion = Instalacion.new(1,"",skq,str,un,uo,ucc,self.no_fases) unless la_instalacion  


      #self.instalacion = la_instalacion
    end

    def get_p
      if @ccto 
	return @ccto.get_p 
      else 
	raise "No se tiene @ccto en get_p de circuitos"
	return 0
      end
    end
    def set_corriente_servicio(a_corriente_servicio)
      self.corriente_servicio = a_corriente_servicio
    end
    def calculate_corriente_servicio
      is_medido ? is_medido : cargas.sum(&:get_i)
    end

    def get_inominal
       cuantizar(calculate_corriente_servicio)
    end

    def cuantizar(is)
      memoria.info "Estoy en cuantizar de circuito de alumbrado"
      memoria.info "is = #{is}"
      b = $MCB.select {|n| n >= is}
      @inominal= ( b.reject{|n| n < is/MARGEN}).first.to_i
      b = $MCB.select {|n| n >= is}
      @inominal= ( b.reject{|n| n < is/MARGEN}).first.to_i
      memoria.info "inominal = #{@inominal}"
      return @inominal
    end


    def get_corriente_servicio
      calculate_corriente_servicio
     #self.corriente_servicio ? self.corriente_servicio : calculate_corriente_servicio
    end
=begin
    def corriente_servicio=(a_corriente_servicio)
      if a_corriente_servicio == 0
	raise "alguien quiere cambiar la corriente de servicio que vale #{self.corriente_servicio} con el nuevo valor de  #{a_corriente_servicio}"    
	else
	  super(a_corriente_servicio)
       end
    end
=end

    def calcula(a_instalacion)
      @fuente = a_instalacion.find_by_nombre("SalidaTrafo")
      raise "No se pudo encontrar Salida Trafo en calcula de circuitos"  unless @fuente

      la_instalacion = a_instalacion

       raise "Circuito sin cargas" unless self.cargas.count > 0
       raise "el presupuesto no tiene circuitos" unless self.presupuesto.circuitos.any?

       #Esta es una estrategi de deletacion, cada tipo de criuito l omaje una clsase pero como los dato son comunes se guarda aca
       letras = Electrico::TipoCircuito.find_by(:id => tipo_circuito_id).letras
       case letras
       when "L" #Ejemplo de la Guia de Potencia de Legrand pag 48
	@ccto=CircuitoLegrand.new(self)
       when "A" #Calculo de un circuito alimentador
	 self.es_alimentador=true
	 self.cargas.delete_all
	 self.presupuesto.circuitos.no_alimenta.each{|circuito| circuito.cargas.each{|carga| self.cargas << carga.dup}}
	 @ccto=D::CircuitoAlimentador.new(self)
       when "F"
         if self.cargas.each.count == 0
           self.destroy!
         end
         #elf.es_alimentador=false
         @ccto=D::CircuitoEnchufe.new(self)
      else
	 if self.cargas.each.count == 0
	   self.destroy!
	 end
	 memoria.info "Calculo de un circuito de enchufes"
	 @ccto=D::CircuitoDesigner.new(self)
       end
    
       return if @ccto.nil?
       @ccto.configurar if @ccto  #configura el conductor y otros detalles

       #Em esta etapa se calcula la instalación. Hay dos tipos de instlación, la de Legran y la normal
       if tipo_circuito_id == 13
	 la_instalacion.dimensiona_legrand(@ccto, self,self.presupuesto)
	 la_instalacion.nueva_linea(@ccto,self,self.presupuesto)
	 memoria.info "Terminando instalacion"
	 la_instalacion.termina_instalacion
	 self.presupuesto.set_instalacion(la_instalacion)

       else
	 #Qué es esta parte
	 #Uno: Estmados en un circuito que se ha creado por el usuario. La instalación ya existe. Lo que se hace aquí es actualizar la instalación existente para agregar el nuevo circuito.
	 #
	 #Se obtiene la curva. Esto depende de si es un alimentador o no
	 self.curva    = @ccto.get_curva if @ccto
	 self.curva    = "B" if self.largo > 60 #la curva B es la más sensible, actua ante corrientes bajas de cortoc.
	   #intensidades débiles de cortocituio pagina 257 guia de potencia
       #    #circuitos largos
       #
	 self.tension  = @ccto.get_tension 
	 self.no_fases = @ccto.get_polos

	 #Los atributos de curva,tension y no_fase son críticos a la hora de que se pueda encontrar un disyuntor adecuado, durante el proceso de actualización de la instalación.
	 #
	 
	 memoria.info "Dimensionando acometida" 
	 #Para dimensionar la acometida, no se necesitan los datos sobre los circuitos, solo del total de lcas cargas
	 la_instalacion.dimensiona_acometida(self.presupuesto)

	 memoria.info "Dimensionando alimentador"
	 #Para dimensionar el alimentador, se utiliza un objeto circuito del tipo alimentador y se le entregan los datos generales de cargas. Esta etapa debe ser previa al diseño de lineas para que se considere el poder de corte
	 la_instalacion.dimensiona_alimentador(@ccto,self,self.presupuesto)

	 #Para este circuito se agrega una nueva linea y para cada cicuito que se agregue
	 memoria.info "Dimensionando nueva linea"
	 la_instalacion.nueva_linea(@ccto,self,self.presupuesto)

	 memoria.info "Terminando instalacion"
	 la_instalacion.termina_instalacion
	 self.presupuesto.set_instalacion(la_instalacion)
	 #La instalacióna ha quedado lista en este punto y guardada en el presupuesto.
       end

       #----- En esta etapa se hacen cálculos para la ejecución de la obra. Como la búsqueda de los automáticos en la bodega.
       memoria.info "Rescatando automaticos D1, D2 y D3"
       @proteccion_D1          = la_instalacion.get_automatico_D1
       #D1 no es un automatíco sino un objeto disyuntor que contiene las especificcaciones de un automático que deberá funcionar como protección adicional en el Empalme
       #
       raise "proteccion_D1 es nula" unless @proteccion_D1
       @proteccion_D2          = la_instalacion.get_automatico_D2
       #D2 no es un automatíco sino un objeto disyuntor con las especificaciones de un automatico que deberá funcionar en la posición D2, o automático general
       #self.presupuesto.automatico_general = la_instalacion.get_automatico_D2
       #self.presupuesto.barra_general = la_instalacion.get_barra_general
       #
       #
       @proteccion_D3          = la_instalacion.get_automatico_D3(self.id)
       #D3 no es un automatico sino un objeto disyuntor con las especificacione de un automatico que deberá funciona en la posición D3, protección de línea
       #
       #--- Guardndo el esquelo de disyuntores en este circuito, se hace para que se pueda dibujar el diagrama unlineal en caso de que se pierda el archivo de instalación
       self.presupuesto.set_proteccionD1(nil)
 #      self.presupuesto.set_proteccionD2(nil)
       self.set_proteccionD3(nil)

       self.presupuesto.set_proteccionD1(@proteccion_D1.dup) if @proteccion_D1
  #     self.presupuesto.set_proteccionD2(@proteccion_D2.dup) if @proteccion_D2
       self.set_proteccionD3(@proteccion_D3.dup) if @proteccion_D3

       #El largo de este circutio se ha supuesto como el máxim spur, es una simplificación.
       self.max_spur = self.largo unless self.max_spur 

       #Ahora se aclara el problema de las fases y los polos. Pero es una simplicación. Cuando las fases son dos, se supone que es bifaśico
       case self.no_fases #
	 when 1 #corresonde a dos polos en automatico (fase y neutro)
	   self.es_monofasico = true
	 when 2 #corresponde a dos polos en automatico (fase 1 o fase 2)
	   self.es_monofasico = true  #Debiera ser bifasico
	 when 3 #Corresponde a alimentacion trifasica, el neutro no se ocupa hasta llegar a los circuitos que sean del tip monofasico
	   #Esto no es tan cierto, en realidad me refereía al número de conductores que ban por un tubo, pero con el tiempo, está claro que no puede haber solo uno. Cuando hay más será que se está alimentando un ciruicto  con dos fases o con fase y neutro
	   self.es_trifasico = true
       end

       return if tipo_circuito_id  == 13

       #---------   fin de circuito 13 ----- "Es un un circuito de referencia no usar materiales
       #
       #Se buscan en la bodega los materiales. No siempre están ...
       resetea_materiales(self)
       raise "proteccion_D1 es nula" unless @proteccion_D1
       pick_automatico_D1(self,@proteccion_D1)
       pick_automatico_D2(self,@proteccion_D2,la_instalacion)

       #Se actualizan todas lsa propiedades de este circuitio con el de referencia, a fin de que se puedan mostrar en informes.
       self.fpc                = @ccto.get_fpc 
       self.fp                 = @ccto.get_fp  
       self.carga_conectada    = @ccto.get_carga_conectada 
       self.corriente_servicio = @ccto.get_corriente_servicio
       @corriente_servicio     = self.corriente_servicio
       self.inominal           = @ccto.get_inominal
       self.izth               = @ccto.get_inominal #El conductor se elige para el 90 de la corriente de servicio. La inominal es una cuantización de is #Puede que no esté bien
       self.conductor          = @ccto.get_conductor

       self.Ia                 = @proteccion_D3.get_Im if @proteccion_D3 #Corriente de activación inmediata
       self.LMax               = calculate_LMax(self.conductor,self.proteccionD3,@ccto) if @proteccion_D3 #Largo máximo que soporta este circuito de acuerdo al tiepo de conductor, la protección y otras características del cirucito
       self.automatico         = pick_automatico_D3(self,@proteccion_D3) if @proteccion_D3# Solo se usa en recalcula. Es el automático que se encuentre en la bodega
       self.tiene_automatico = true if self.automatico
       self.iteracion = 1
       self.AV                 = calculate_AV(self,@ccto) if @proteccion_D3 #La caída de voltaje de este circuitos. Si no se satisface debe volverse a calcular
       self.es_valido          = true if self.AV < @ccto.get_MAX_AV and self.largo < self.LMax if @proteccion_D3



       materializa_conductor(self)
       materializa_canalizacion(self) if es_canalizable(self)

       resetea_costos(self)
       valoriza_materiales_de(self) #Agrega solo al total de costo
       reporta_costo_de_mano_de_obra(self,1)
       reporta_costo_de_picado(self,8)
       memoria.info "Terminado el costo de picado"
       memoria.info "Llamando a totaliza_los_costos"
       totaliza_los_costos(self)
       memoria.info "Volví de totaliza los costos"

       memoria.info "Llamando a presupuesto save"
       #self.presupuesto.set_instalacion(la_instalacion)
   #    self.presupuesto.instalacion = la_instalacion
       #self.presupuesto.save! #demora diez segundos
       #OJO: TODO: No Es clave para que guarde o no.
       #memoria.info "Terminado presupuesto save"
       self.save!
    end

    def recalcula
       memoria.info "Estoy en recalcula de circuitos"
       self.Ia                 = @proteccion_D3.get_Im if @proteccion_D3
       self.LMax               = calculate_LMax(self.conductor,self.proteccionD3,@ccto) if @proteccion_D3
       self.automatico         = pick_automatico_D3(self,@proteccion_D3) if @proteccion_D3
       self.tiene_automatico = true if self.automatico
       self.iteracion = 1
       self.AV                 = calculate_AV(self,@ccto) if @proteccion_D3
       self.es_valido          = true if self.AV < @ccto.get_MAX_AV and self.largo < self.LMax if @proteccion_D3

       
       resetea_costos(self)
       valoriza_materiales_de(self) #Agrega solo al total de costo
       reporta_costo_de_mano_de_obra(self,1)
       reporta_costo_de_picado(self,8)
       totaliza_los_costos(self)

       self.save!
    end

    def ccto
      @ccto
    end

    def fp #parche 
      #self.fp  = @ccto.get_fp(*cargas)
      0.9
    end

    #------------------ Atributo proteccionD3 --------------------------------
    def set_proteccionD3(a_proteccionD3)
      self.proteccionD3 = a_proteccionD3
    end

    def get_proteccionD3
      self.proteccionD3
    end

    def get_D3
      @proteccion_D3
    end

    
    def resetea_costos(circuito)
      circuito.costo = 0
      circuito.costos.delete_all
    end

    def resetea_materiales(circuito)
      circuito.materiales.delete_all
    end

    #Agrega los materiales del conductor a la lista de materiales del circuito, para que luego se totalizen en la categoría de circuito
    def materializa_conductor(circuito)
      circuito.conductor.materiales.each do |material|
	memoria.info "Buscando tipo de material para material #{material.inspect}"
	circuito.materiales.build(:tipo_material_id => material.tipo_material,:cantidad => circuito.largo).save!
      end
    end

    #Para cada material de la lista de materiales, encuentra el costo y lo agrega a la lista de costos del cicuitoi
    def valoriza_materiales_de(circuito)
      circuito.costo ||= 0
      circuito.materiales.each{
	|m| (
	      if TipoMaterial.exists?(m.tipo_material_id)
		tipo = TipoMaterial.find_by_id(m.tipo_material_id)
		m.costo = tipo.costo  
		#m.save!
		circuito.costo += m.costo * m.cantidad
	      else
		memoria.debug "No se ha encontrado el tipo de material #{m.tipo_material_id}"
	      end
	  )
	}
    end


    #Pickea un automatico de la bodega
    def pick_automatico_D3( circuito, proteccion)
      #Los automáticos en la bodega deben estar ajustados al maestro de productos, llamado automático
      memoria.info "Estoy en pick_automatico_D3"
      automatico = Automatico.where(:corriente_nominal => proteccion.In,:poder_corte => proteccion.pdc,:es_diferencial => false, :tension => proteccion.tension,:curva => proteccion.curva).first
      memoria.info "Automatico es #{automatico.inspect}" if automatico
      begin
	m=automatico.materiales.first
	#circuito.materiales.create(:tipo_material_id => m.tipo_material_id,:cantidad => 1) if m
	memoria.info "Se ha encontrado material para #{m.inspect}"
      rescue
	memoria.info "No se ha encontrado material para automatico #{automatico.inspect}"
      end
      return automatico 

    end

    def pick_automatico_D2(circuito,proteccion,instalacion)
      memoria.info "Estoy en pick_automatico_D2"
      automatico = Automatico.where(:corriente_nominal => proteccion.In,:poder_corte => proteccion.pdc,:es_diferencial => false, :tension => proteccion.tension,:curva => instalacion.get_curva_mas_lenta).first
      begin
	if automatico
	  memoria.info "Se encontró automático en la bodega #{automatico.inspect}"
	else
	  memoria.info "No se ha encontrado automático para #{proteccion.In}A, pdc #{proteccion.pdc} y curva #{instalacion.get_curva_mas_lenta}"
	end
	if automatico and automatico.materiales.each.count > 0
	  m=automatico.materiales.first
      
	  circuito.materiales.build(:tipo_material_id => m.tipo_material_id,:cantidad => 1).save! 
	  memoria.info "Se ha encontrado material #{m.inspect}"
	else
	  memoria.info "No Se ha encontrado material para #{automatico.inspect}"
	end
      rescue
	  memoria.debug "No se ha encontrado automático para #{proteccion.In}A, pdc #{proteccion.pdc} y curva #{instalacion.get_curva_mas_lenta}"

      end
     return automatico 
    end

    def pick_automatico_D1(circuito,proteccion)
      memoria.info "Estoy en pick_automatico_D1"
      #proteccion = circuito.proteccionD2
      raise "proteccion es nula"  unless proteccion

      automatico = Automatico.find_by(:corriente_nominal => proteccion.In,
				      :poder_corte => proteccion.pdc, 
				      :es_diferencial => false, 
				      :tension => proteccion.tension,
				      :curva => proteccion.curva)
      #automatico = Automatico.find_by(:corriente_nominal => proteccion.In,:poder_corte => proteccion.pdc,:es_diferencial => false, :tension => proteccion.tension,:curva => proteccion.curva)
      #utomatico = Automatico.where(:corriente_nominal => proteccion.In,:poder_corte => proteccion.pdc,:es_diferencial => false, :tension => proteccion.tension,:curva => proteccion.curva).first
      memoria.info "No fue encontrado material de automatico para #{proteccion.inspect}" unless automatico
      memoria.info "Fue encontrado automatico para #{proteccion.inspect}" if automatico
      memoria.info "Automático es #{automatico.inspect}" if automatico
      begin
        m=automatico.materiales.first
	memoria.info "Se ha encontrado material #{m.inspect}" if m
        circuito.materiales.build(:tipo_material_id => m.tipo_material_id,:cantidad => 1) 
	memoria.info "Se ha encontrado material #{m.nombre}"
	memoria.info "------------------------------"
      rescue Exception => e

	memoria.info "Estoy en rescue #{e.message}"
        memoria.info "No se ha encontrado material para #{proteccion.inspect}" unless m
	begin
          doc = Nokogiri::HTML(open("http://www.dartel.cl/"))
	rescue Exception => e
	  memoria.info "No fue posible crawlear la info #{e.message}"
	end

      end
      memoria.info "Saliendo de pick_automatico_D1"
      return automatico if m
    end
   

    #la longitud máxima protegida
    def calculate_LMax(conductor,proteccion,ccto)
      @lmax = ccto.calculate_LMax(conductor, self.tension, self.Ia)
    end

    #Calcula la capida de voltaje
    def calculate_AV(circuito,ccto)
      @av= ccto.calculate_AV(circuito.conductor,circuito.fp, circuito.max_spur, circuito.corriente_servicio, circuito.tension, circuito.no_fases)
    end


    def reporta_costo_de_mano_de_obra(circuito,horas_por_metro)
        raise "horas_por_metro indefinido en reporta costo de mano de obra" unless horas_por_metro
	raise "circuito está indefinido en reporta costo de mano de obra" unless circuito
	raise "no desta definido el largo para el circuito #{circuito.id}" unless circuito.largo
	#estos son costos de mano de obra de instalación por metro  y circuito
	memoria.info "Se calcula el costo de la mano de obra de  instalacion"
	tipo=TipoCosto.find_by_descripcion('Instalador HH')
	circuito.costos.build(:descripcion => "Cableado de circuito #{circuito.id} #{circuito.nombre} por un #{tipo.descripcion}",:tipo_costo_id => tipo.id,:cantidad => circuito.largo * horas_por_metro)
    end

    #Anota los costos la columna de costos del circuito
    def reporta_costo_de_picado(circuito,horas_por_metro)
	#extension_picado
	memoria.info "Calculando el costo de picado"
	if circuito.extension_picado and circuito.extension_picado >0
	  tipo=TipoCosto.find_by_descripcion('Instalador HH')
	  circuito.costos.build(:descripcion => "Picado de #{circuito.extension_picado} metros por un #{tipo.descripcion}",:tipo_costo_id => tipo.id,:cantidad => circuito.extension_picado * horas_por_metro)
	end
    end

    #Determina si, según la norma se puede o no meter los ocnductores en la canalizaicon escogida
    def es_canalizable(circuito)
      seccion_ocupada_en_ducto= (circuito.no_fases + 2)*circuito.conductor.seccion+2*(circuito.conductor.espesor)
      area_disponible = Math::PI * (circuito.canalizacion.diametro_en_mm/2)**2
  porcentaje_ocupacion =  100*seccion_ocupada_en_ducto/area_disponible
      memoria.info "Area disponible en la canalización es"
      memoria.info area_disponible
      memoria.info "Seccion Ocupada en Ducto por la tripleta es #{seccion_ocupada_en_ducto}"
      memoria.info "Se ocupa solamente #{porcentaje_ocupacion}%"
      memoria.info "Se puede ocupar hasta 60%"

      return true if porcentaje_ocupacion < 60
    end

    #Ecnuentra los materiales para la canalizacion
    def materializa_canalizacion(circuito)
      memoria.info "Calculando costos de canalización"
      memoria.info "Canalización es #{circuito.canalizacion.nombre} diámetro #{circuito.canalizacion.diametro_en_mm} mm "
      memoria.info "Encuentra un material para la canalización especificada"
      if circuito.canalizacion.materiales.any?
	material = circuito.canalizacion.materiales.first
	memoria.info "Se encontró el material #{material.inspect}"
	memoria.info "Ahora se buscará el tipo de material para ese material"
	tipo_material = material.tipo_material
	memoria.info "El tipo de material es #{tipo_material.inspect}"
	if tipo_material
	  circuito.materiales.build(:tipo_material_id => tipo_material.id,:cantidad => circuito.largo).save!
	  memoria.info "Se agregó al material a los materiales del circuito"
	  return true
	else
	  memoria.info "No se encontraron tipo de material para el material de la canalización"
	  return false
	end
      else
	memoria.info "No se encontraron materiales para la canalización"
      end
    end

    #Busca en el tipo de costos, el monto y lo agrega al costo total en la varaible circuito.costo. El efecto es totalizar los costos.
    def totaliza_los_costos(circuito)
	memoria.info "LLegué a totaliza los costos"
	circuito.costos.each{ |c| (
	  memoria.info ".... costo"
	tipo = TipoCosto.find_by_id(c.tipo_costo_id);
	costo = tipo.monto unless !c.costo_unitario.blank?;
	c.save!;#nless c.marked_for_destruction? ;
	circuito.costo += circuito.costo * c.cantidad )}
	memoria.info "Termine en totaliza los costos"
    end

  end
end

