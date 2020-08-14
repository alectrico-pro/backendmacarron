#memoria = Logging.linea(STDOUT)
#require 'json/ld'
#encoding:UTF-8
#require_relative 'memo'
#Caracteriza a una instalacion eléctrico
  #Tiene nodos generíco para conectar las partes
  #Las partes pueden ser alimentadores y cortocircuitos.
  ##Los alimentadores tienen impedancia separada por grupos de conductores
  #Los Cortocircuitos se forman en diferentes nodos con corrientes pasando por alimentadores
  #Ahora le agregaré circuitos que podrían ser llamados aquí como líneas
  #
  #Contiene los elementos de una instalacion
module D

class D::Instalacion < D::Lista

  include Linea

  def self.memoria
    Logging::Logger.new('D::Instalacion')
  end


  attr_reader :Skq, :Str,:Uo,:nombre

  def initialize
    super()
    linea.info "Instalación inicializada"
  end

  def save
    raise "Estoy en save de D::Instalacion"
  end

  def save!
    #Usado por FactoryBot.lint
  end

  def self.load json
  end

  def get_id
   1
  end

  def self.json_create json
    barra_general = nil
    obj = self.new

    unless json.nil?
          begin 
            hash = JSON.parse json
	  rescue
            hash = JSON.parse "{}" 
	  end
	  unless hash.empty?
	    hash.each do |key, json_string|
	      case json_string["json_class"]
	      when "D::Alimentador"
		nodo = D::Alimentador.json_create(json_string)
	      when "D::Trafo"
		nodo = D::Trafo.json_create(json_string)
	      when "D::Barra"
		nodo = D::Barra.json_create(json_string)
		nodo.barras = obj.barras
                nodo.get_coleccion.each do |disyuntor|
		  disyuntor.stock = obj.stock
		end
		barra_general = nodo
	      when "D::Disyuntor"
		nodo = D::Disyuntor.json_create(json_string)
                nodo.stock = obj.stock
	      when "D::EquipoMedida"
		nodo = D::EquipoMedida.json_create(json_string)
	      when "D::CortoCircuito"
		nodo = D::CortoCircuito.json_create(json_string)
              when "D::CortoCircuitoTrifasicoSimetricoBT"
		nodo = D::CortoCircuitoTrifasicoSimetricoBT.json_create(json_string)
              when "D::CortoCircuitoBifasicoBT"
		nodo =  D::CortoCircuitoBifasicoBT.json_create(json_string)
	      when "D::FallaATierraBifasica"
		nodo =  D::FallaATierraBifasica.json_create(json_string)
	      when "D::FallaATierraTrifasicaBT"
                nodo = D::FallaATierraTrifasicaBT.json_create(json_string)
	      when  "D::Envolvente"
                nodo =  D::Envolvente.json_create(json_string)
	      when "D::EntradaTrafo"
                nodo = D::EntradaTrafo.json_create(json_string)
	      when "D::SalidaTrafo"
		nodo = D::SalidaTrafo.json_create(json_string)
	      when "D::Instalacion"
		attrs = JSON.parse(json_string['item'])
		obj.no_polos = attrs['no_polos']
		obj.Uo       = attrs['Uo']
		obj.T        = attrs['T']
		obj.regimen  = attrs['regimen']
		obj.stock    = Stock.new
		obj.barras   = Barras.new
	      else
		raise "Hay un problema con la serialización #{json_string.inspect}: no reconocido"
                #nodo = D::Nodo.json_create(json_string)
	      end
	      #ttps://www.skorks.com/2010/04/serializing-and-deserializing-objects-with-ruby/

	      unless json_string['json_class'] == "D::Instalacion" 
		if nodo and nodo.nombre
                  self.memoria.info "Agregando en load de instalacion #{json_string}"
		 obj.replace_or_encola_nodo( nodo  )
		end
	      end
	    end
	  end

	  if barra_general
	    begin
	      self.memoria.info "Empatando los disyuntores de la barra con los alimentadores que le corresponden"
	    rescue Exception => e
	      byebug
	    end
	    barra_general.get_coleccion.each do |disyuntor|
	       disyuntor.aguas_abajo = obj.find_by_nombre("Linea"+disyuntor.id.to_s)
	       disyuntor.aguas_arriba = barra_general
	    end	    
	    obj.replace_or_encola_nodo( barra_general)
	  end
#	  memoria.info "Parsed as json"
          #linea.error "Error en json_create instalacion, no hay objetos." if hash.empty?
#	  memoria.info "Nodos agregados"
#	  memoria.info obj.get_nodos.count.to_s
    end

    obj
  end

  def nombre
    @nombre
  end

  def self.ex_dump obj
    hash = {}
    c=1

    @no_polos ||= 1
    hash[c.to_s] = {
       'json_class' => 'D::Instalacion',
       'item'       => {'no_polos' => obj.no_polos,
                        'Uo'       => obj.Uo,
                        'T'        => obj.T,
                        'regimen'  => obj.regimen
                        }.to_json
    }

    obj.get_nodos.each do |n|
      c += 1
      hash[c.to_s] = n.to_json
      memoria.info n.class.name
    end

    memoria.info "dump"
    return hash.to_json if obj
  end

  def to_json(*a) 

    obj = self
    hash = {}
    c=1
    @no_polos ||= 1
    hash[c.to_s] = {
       'json_class' => 'D::Instalacion',
       'item'       => {'no_polos' => obj.no_polos,
                        'Uo'       => obj.Uo,
                        'T'        => obj.T,
                        'regimen'  => obj.regimen
                        }.to_json
    }

    obj.get_nodos.each do |n|
      c += 1
      hash[c.to_s] = n.to_json
      memoria.info n.class.name
    end

    memoria.info "to_json"
    return hash.to_json if obj
  end

  def barras
    @barras
  end

  def regimen=(a_regimen)
    @regimen = a_regimen
  end

  def clean
    @stock                 = nil
    @barras                = nil
    @empalmes              = nil
    @transformadores       = nil

     get_nodos.each do |n|
       n.clean
     end
    
     @cleanned = true
  end

  #a_Str=630 o 315
  def configurar(a_id, a_nombre,a_Skq=500,a_Str=630,a_Un=400,a_Uo=231,a_Ucc=4,a_no_polos=2,a_T=30,a_regimen="TT")
    @cleanned = false
    memoria.info "Estoy en configurar de Instalación"
    #
    @regimen = a_regimen
    @T=a_T
    @id=a_id
    @nombre= a_nombre
    @no_polos = a_no_polos
    @instalacion_terminada = false
    @Uo                    = a_Uo #Tension de servicio o salida del transformador en BT Generalmente 231
    @Skq                   = a_Skq
    @Str                   = a_Str
    @Ucc                   = a_Ucc #Tensión de aislamiento del transformador en %
    @Un                    = a_Un #Tension nominal entre fases de la instalacion Generalmente 400
    @nodos                 = []
    @stock                 = Stock.new
    @barras                = Barras.new
    @empalmes              = Empalmes.new
    @transformadores       = Transformadores.new
    return self
  end

  def stock
    @stock
  end

  def stock=(a_stock)
    @stock = a_stock
  end

  def barras=(a_barras)
    @barras = a_barras
  end

  def empalmes=(a_empalmes)
    @empalmes = a_empalmes
  end

  def transformadores=(a_transformadores)
    @transformadores = a_transformadores
  end

  def cleanned?
    @cleanned
  end

  def add_nodo(a_nodo)
    #a_nodo.set_instalacion self
    super(a_nodo)
  end

  def regimen
    @regimen
  end

  def tension #La tensión de la instalacion es la de la salida del trafo
   @Uo
  end

  def T=(a_T)
    @T = a_T
  end

  def T
    @T
  end


  def termina_instalacion
    #memoria.debug "Estoy en termina_instalacion de instalacion"
    self.calcula
    self.puts
    self.tree

    memoria.info ":::::::::::::::::::::::::::::::::::::::::"
    @instalacion_terminada = true
  end


  def tramo_fijo#(a_presupuesto)
  #  memoria.info "Estoy en tramo fijo"
    #El tramo fijo es el mismo para cuando se pide agregar lineas nuevas a una instalacion.
    #
    @red           = EntradaTrafo.new(@Skq,@Un)
    raise @red.nombre unless @red
    encola_nodo(@red)

    @fuente        = SalidaTrafo.new(@Str,@Ucc,@Un)
    encola_nodo(@fuente)
    @red.freeze
    t = D::Transformadores.new
    @trafo         = BuscaTrafo.new(@Str,D::Transformadores.new).trafo
    @trafo.dimensiona(@Un)
    encola_nodo(@trafo)
    @fuente.freeze
    
=begin
    forro_XTU      = Forro.find_by_id(11)
    ccto           = CircuitoIs.new(@trafo.In,forro_XTU)
    seccion        = ccto.get_conductor.seccion
    no_conductores = ccto.get_no_conductores
   / iz             = ccto.get_conductor.get_iz * no_conductores
    largo          = a_presupuesto.largo
    @tramo_aereo   = Alimentador.new(iz,largo, seccion,no_conductores, seccion,no_conductores, 95,1,'Tramo Aereo',ccto) #Pendiente calclo de conductor de proteccion

    if @no_polos > 1
      @coci_en_trafo         = CortoCircuitoTrifasicoSimetricoBT.new("Coci en Trafo", @frafo.fase_aguas_arriba.R, @fuente.fase_aguas_arriba.X,@Uo)

      encola_nodo(@coci_en_trafo)
      encola_nodo(@tramo_aereo)

      @coci_en_poste          = CortoCircuitoTrifasicoSimetricoBT.new("Coci en Poste", @tramo_aereo.fase_aguas_arriba.R,@tramo_aereo.fase_aguas_arriba.X,@Uo)
    else
      @coci_en_trafo         = CortoCircuitoBifasicoBT.new("Coci en Trafo", @trafo.fase_aguas_arriba.R, @fuente.fase_aguas_arriba.X,@Uo)

      encola_nodo(@coci_en_trafo)
      encola_nodo(@tramo_aereo)
	   
      @coci_en_poste          = CortoCircuitoBifasicoBT.new("Coci en Poste", @tramo_aereo.fase_aguas_arriba.R,@tramo_aereo.fase_aguas_arriba.X,@Uo)
    end

    replace_or_encola_nodo(@coci_en_poste)

    @tramo_aereo.coci_maximo = @coci_en_trafo
=end
    return self
  end
  
  def k
    #tabla 10.22 Nch 4/2003
    @D2 = find_by_nombre("D2: Automático General en Tablero")
    if @D2 and @D2.automatico
      case @D2.automatico.class.to_s

      when "AutomaticoCurva"
	case @D2.automatico.curva
	when "C"
	  3.5
	when "B"
          2.5
	else
	  3.5
        end

      when "AutomaticoFijo"
	if @D2.automatico.In > 63
          1.25
	else
	  2.5
	end

      when "AutomaticoRegulable"
	if @D2.automatico.present?
	  if (@D2.automatico.Ir.present? and @D2.automatico.Ir > 63) or
	     (@D2.automatico.get_Ir.present? and @D2.automatico.get_Ir > 63)
	    return 1.25
	  else
	    return 2.5 
	  end
	end
      else
	return @D2.automatico.class
      end
    else
      return -1
    end
  end       

  def create(a_presupuesto) #Esta es una forma rápida para crear una instalacíón. La original se llama desde circuito, cuando el usuario crea un circuito en la ventana de circuitos, correspondiente al paso circuito del presupuesto.

    @presupuesto = a_presupuesto
    #------------ EMPALME -----------------------------------------------
    #
   #@D1= select_D1("D")
    @D1 = D::Breaker.new(nil,a_presupuesto.casa_habitacion ? D::Cargador::Carga.render(:corriente_de_servicio_de_vivienda,a_presupuesto) : D::Cargador::Carga.render(:corriente_de_servicio_de_local_comercial,a_presupuesto) ,0.9,'D1: Interruptor en Empalme',@stock,30,220,1,'TT','D')

    #is= D::Is.new
    #is << @presupuesto
    ccto = D::CircuitoAlimentador.new(a_presupuesto)

    potencia_instalada_de_vivienda = D::Cargador::Carga.render(:potencia_instalada_de_vivienda, a_presupuesto)

    potencia_instalada_de_local_comercial = D::Cargador::Carga.render(:potencia_instalada_de_local_comercial, a_presupuesto)

    if a_presupuesto.casa_habitacion
      @equipo_de_medida = EquipoDeMedida.new( potencia_instalada_de_vivienda)
    elsif a_presupuesto.local_comercial
      @equipo_de_medida = EquipoDeMedida.new( potencia_instalada_de_local_comercial)
    else
      @equipo_de_medida = EquipoDeMedida.new( potencia_instalada_de_vivienda)
    end


    #@equipo_de_medida = EquipoMedida.new(is.to_tipo_construccion, ccto.get_potencia_instalada, @presupuesto.no_fases,"Equipo de Medidas", @presupuesto, @empalmes)
    @equipo_de_medida.selecciona_empalme
    @no_polos = @equipo_de_medida.no_fases == 3 ?  @equipo_de_medida.no_fases : 1

    replace_or_encola_nodo(@equipo_de_medida)

    a_presupuesto.no_fases = @no_polos

    #---------------- ACOMETIDA -----------------------------------------
    ccto.configurar
    conductor      = ccto.get_conductor
    no_conductores = ccto.get_no_conductores


    seccion        = conductor.seccion
    largo          = ccto.get_largo
    iz             = conductor.get_iz

    @acometida = Alimentador.new('Acometida')
    @acometida.configurar(iz, largo, seccion,no_conductores, seccion,no_conductores, seccion,no_conductores,'Acometida',ccto) 

    @fuente = find_by_nombre("SalidaTrafo")

    @coci_en_trafo = @no_polos > 1 ? CortoCircuitoTrifasicoSimetricoBT.new("Coci en Trafo", @fuente.fase_aguas_arriba.R, @fuente.fase_aguas_arriba.X,@Uo) : CortoCircuitoBifasicoBT.new("Coci en Trafo", @fuente.fase_aguas_arriba.R, @fuente.fase_aguas_arriba.X,@Uo)

    replace_or_encola_nodo(@coci_en_trafo)
    replace_or_encola_nodo(@acometida)
    @acometida.coci_maximo = @coci_en_trafo

    @falla_en_empalme = @no_polos > 1 ? FallaATierraTrifasicaBT.new("Falla en Empalme",@acometida.falla_aguas_arriba.Rfalla, @acometida.falla_aguas_arriba.X,@Uo) : FallaATierraBifasica.new("Falla en Empalme",@acometida.falla_aguas_arriba.Rfalla, @acometida.falla_aguas_arriba.X,@Uo)

    @acometida.coci_minimo   = @falla_en_empalme
    replace_or_encola_nodo(@falla_en_empalme)
    replace_or_encola_nodo(@acometida)

    @coci_en_empalme = @no_polos > 1 ? CortoCircuitoTrifasicoSimetricoBT.new("Coci en Empalme", @acometida.fase_aguas_arriba.R,@acometida.fase_aguas_arriba.X,@Uo) : CortoCircuitoBifasicoBT.new("Coci en Empalme", @acometida.fase_aguas_arriba.R,@acometida.fase_aguas_arriba.X,@Uo)

    replace_or_encola_nodo(@coci_en_empalme)
    replace_or_encola_nodo(@D1)

    #------------------- ALIMENTADOR --------------------------------

    ccto = CircuitoAlimentador.new(@presupuesto) #Así los circuitos de presupuesto serán interpretados como carga

    @cargas                   = @presupuesto.cargas
    ccto.configurar

    @alimentador = Alimentador.new('Alimentador')
    @alimentador.configurar( ccto.get_conductor.get_iz, ccto.get_largo, ccto.get_conductor.seccion,ccto.get_no_conductores, ccto.get_conductor.seccion,ccto.get_no_conductores, ccto.get_conductor.seccion,ccto.get_no_conductores,'Alimentador',ccto,31)

    replace_or_encola_nodo(@alimentador)

    @coci_en_tablero = @no_polos > 1 ? CortoCircuitoTrifasicoSimetricoBT.new("Coci en Tablero", @alimentador.fase_aguas_arriba.R,@alimentador.fase_aguas_arriba.X,@Uo) : CortoCircuitoBifasicoBT.new( "Coci en Tablero",@alimentador.fase_aguas_arriba.R,@alimentador.fase_aguas_arriba.X,@Uo)

    @falla_en_tablero = @no_polos > 1 ? FallaATierraTrifasicaBT.new("Falla en Tablero",@alimentador.falla_aguas_arriba.Rfalla, @alimentador.falla_aguas_arriba.X,@Uo) : FallaATierraBifasica.new("Falla en Tablero",@alimentador.falla_aguas_arriba.Rfalla, @alimentador.falla_aguas_arriba.X,@Uo)


    replace_or_encola_nodo(@coci_en_tablero)
    replace_or_encola_nodo(@falla_en_tablero)

    @envolvente = Envolvente.new("Tablero",1)

    replace_or_encola_nodo(@envolvente)

    @curva_D2                      = select_curva_D2
    @D2                            = select_D2(@curva_D2)

    replace_or_encola_nodo(@D2)

    @B3 = find_by_nombre("B3: Barra General en Tablero")

    coleccion = @B3.get_coleccion if @B3

    @B3                            = select_B3 unless @B3
    coleccion = @B3.coleccion

    replace_or_encola_nodo(@B3)
    @alimentador.coci_maximo       = @coci_en_empalme
    @alimentador.coci_minimo       = @falla_en_tablero

    replace_or_encola_nodo(@alimentador)
    
    @presupuesto.circuitos.each do |circuito|
      memoria.info "Parametrizando los circuitos del presupuesto"
      if circuito.tipo_circuito.letras == "F"
	memoria.info "Es un circuito Libre F"
        @ccto=D::CircuitoEnchufe.new(circuito) 
      else
	memoria.info "Es un circuito de Designer"
	@ccto= D::CircuitoDesigner.new(circuito)
      end

       #Datos disponibles antes de calcular la línea

       circuito.curva    = @ccto.get_curva 
       circuito.curva    = "B" if @presupuesto.largo > 60
       circuito.tension  = @ccto.get_tension 
       circuito.no_fases = @ccto.get_polos


       nueva_linea(@ccto,circuito,@presupuesto)

       #Datos disponibles depués de calcular la línea
       circuito.fpc      = @ccto.get_fpc
       circuito.fp       = @ccto.get_fp
       circuito.carga_conectada = @ccto.get_carga_conectada
       circuito.corriente_servicio = @ccto.get_corriente_servicio
       circuito.inominal = @ccto.get_inominal
       circuito.conductor= @ccto.get_conductor
       @proteccion_D3    = get_automatico_D3(circuito.id)            
       circuito.Ia       = @proteccion_D3.get_Im
       #circuito.LMax     = calculate_LMax(circuito.conductor,@proteccionD3,@ccto) if @proteccion_D3
       circuito.automatico = circuito.pick_automatico_D3(circuito,@proteccion_D3) if @proteccion_D3
       circuito.tiene_automatico = true if circuito.automatico
       circuito.iteracion = 1
 #      circuito.AV  = circuito.calculate_AV(circuito,@ccto) if @proteccion_D3 
 #      circuito.es_valido  = true if (circuito.AV < @ccto.get_MAX_AV and circuito.largo < circuito.LMax if @proteccion_D3)

       circuito.save!
    end
    termina_instalacion
  end






  def dimensiona_acometida(a_presupuesto)

    @fuente = find_by_nombre("SalidaTrafo")
    raise "No se pudo encontrar Salida Trafo en dimensiona acometida"  unless @fuente

    #La acometida debe se recalculada con cada nueva línea que se agregue
    #memoria.debug "Estoy en dimensiona acometida"
    #memoria.info "  Dimensionando conductor de acometida"

    memoria.info "Instalacion es para casa habitación " if a_presupuesto.casa_habitacion
    memoria.info "Instalacion es para local comercial " if a_presupuesto.local_comercial



    @presupuesto           = a_presupuesto
    @D1                    = select_D1("D")
    
    is = D::Is.new
    is << @presupuesto


    @fuente = find_by_nombre("SalidaTrafo")
    raise "No se pudo encontrar Salida Trafo 1" unless @fuente

    raise "defina is para tipo construccion" unless is.to_tipo_construccion
   # @equipo_de_medida = EquipoMedida.new(is.to_tipo_construccion, is.get_potencia.para_vivienda, @presupuesto.no_fases,"Equipo de Medidas", @presupuesto, @empalmes)
    @equipo_de_medida = EquipoMedida.new(is.to_tipo_construccion, is.carga_conectada, @presupuesto.no_fases,"Equipo de Medidas", @presupuesto, @empalmes)
  
    #raise @equipo_de_medida.inspect
    memoria.info "Seleccionando empalme"
    @equipo_de_medida.selecciona_empalme
    #raise "es trifásico" if @equipo_de_medida.no_fases == 3
    @no_polos = @equipo_de_medida.no_fases if @equipo_de_medida.no_fases == 3
    memoria.info @equipo_de_medida.empalme.tipo_de_empalme
    memoria.info @equipo_de_medida.empalme.no_fases
 

    replace_or_encola_nodo(@equipo_de_medida)
    @presupuesto.no_fases = @no_polos
    memoria.info "new circuito alimentador para la acometida"
    ccto = CircuitoAlimentador.new(@presupuesto) #Así los circuitos de la instalacion, a actualmente están asociados a presupuesto por razones hitóricas, serán interpretados como carga
    memoria.info "Ahora se llamará a configurar de Circuito Alimentador"
    ccto.configurar
    memoria.info "Volví desde configurar"
    conductor      = ccto.get_conductor
    memoria.info "Volví de get_conductor el conductor es #{conductor.inspect}"
    no_conductores = ccto.get_no_conductores
    memoria.info "El número de conductores de #{no_conductores}"
    seccion        = conductor.seccion

    largo          = ccto.get_largo
    iz             = conductor.get_iz
  
    @fuente = find_by_nombre("SalidaTrafo")
    raise "No se pudo encontrar Salida Trafo 2" unless @fuente


    if @regimen == "TT"
      @acometida = Alimentador.new('Acometida')
      @acometida.configurar(iz, largo, seccion,no_conductores, seccion,no_conductores, seccion,no_conductores,'Acometida',ccto) #no tiene conductor de tierra en la acometida, pero es más fácil calcularlo pero no considerarlo en la elección de los automáticos
    else #@regimen = "TN"
      @acometida = Alimentador.new('Acometida')
      @acometida.configurar(iz, largo, seccion,no_conductores, seccion,no_conductores, seccion,no_conductores,'Acometida',ccto)

    end

   @no_polos ||= 1
   @fuente = find_by_nombre("SalidaTrafo")
   raise "No se pudo encontrar Salida Trafo 3" unless @fuente
   if @no_polos > 1
      @coci_en_trafo         = CortoCircuitoTrifasicoSimetricoBT.new("Coci en Trafo", @fuente.fase_aguas_arriba.R, @fuente.fase_aguas_arriba.X,@Uo)
      replace_or_encola_nodo(@coci_en_trafo)
      replace_or_encola_nodo(@acometida)
    else
      @coci_en_trafo         = CortoCircuitoBifasicoBT.new("Coci en Trafo", @fuente.fase_aguas_arriba.R, @fuente.fase_aguas_arriba.X,@Uo)
      replace_or_encola_nodo(@coci_en_trafo)
      replace_or_encola_nodo(@acometida)
           
    end
    @acometida.coci_maximo = @coci_en_trafo

    if @no_polos > 1

      @falla_en_empalme = FallaATierraTrifasicaBT.new("Falla en Empalme",@acometida.falla_aguas_arriba.Rfalla, @acometida.falla_aguas_arriba.X,@Uo)

      @acometida.coci_minimo   = @falla_en_empalme
      replace_or_encola_nodo(@falla_en_empalme)
      replace_or_encola_nodo(@acometida)

      @coci_en_empalme        = CortoCircuitoTrifasicoSimetricoBT.new("Coci en Empalme", @acometida.fase_aguas_arriba.R,@acometida.fase_aguas_arriba.X,@Uo)

    else

     @falla_en_empalme = FallaATierraBifasica.new("Falla en Empalme",@acometida.falla_aguas_arriba.Rfalla, @acometida.falla_aguas_arriba.X,@Uo)
      @acometida.coci_minimo   = @falla_en_empalme
      replace_or_encola_nodo(@falla_en_empalme)
      replace_or_encola_nodo(@acometida)

      @coci_en_empalme        = CortoCircuitoBifasicoBT.new("Coci en Empalme", @acometida.fase_aguas_arriba.R,@acometida.fase_aguas_arriba.X,@Uo)
    end
  
    replace_or_encola_nodo(@coci_en_empalme)

    replace_or_encola_nodo(@D1)

  end    


  def dimensiona_alimentador(a_ccto,a_circuito,a_presupuesto)
  
    memoria.info "Estoy en dimensiona alimentador"
    memoria.info "  Dimensionando conductor del Alimentador Principal"

    ccto                      = a_ccto
    @circuito                 = a_circuito
    @presupuesto              = a_presupuesto
    @cargas                   = @circuito.cargas

    memoria.info "Usando un alimentador para dimensionar el alimentador principal: Alimentador"
    memoria.info "Presupuesto.id es #{@presupuesto.id}"
    @presupuesto.circuitos.each{|c| 
      memoria.info "Circuitos son #{c.nombre}"
    }
    ccto = CircuitoAlimentador.new(@presupuesto) #Así los circuitos de presupuesto serán interpretados como carga
    ccto.configurar
    memoria.info "Carga conectada de este #{ccto.nombre} es: #{ccto.get_carga_conectada}"

    @alimentador = Alimentador.new('Alimentador')
    @alimentador.configurar( ccto.get_conductor.get_iz, ccto.get_largo, ccto.get_conductor.seccion,ccto.get_no_conductores, ccto.get_conductor.seccion,ccto.get_no_conductores, ccto.get_conductor.seccion,ccto.get_no_conductores,'Alimentador',ccto,31)
    #memoria.info "Ya se creó el alimentador"

    replace_or_encola_nodo(@alimentador)
    #memoria.info "Ya se encoló el alimentador"
  

    if @no_polos > 1 #Esto está condicionado a los polos de l equipo de medida
      @coci_en_tablero    = CortoCircuitoTrifasicoSimetricoBT.new("Coci en Tablero", @alimentador.fase_aguas_arriba.R,@alimentador.fase_aguas_arriba.X,@Uo)
      @falla_en_tablero   = FallaATierraTrifasicaBT.new("Falla en Tablero",@alimentador.falla_aguas_arriba.Rfalla, @alimentador.falla_aguas_arriba.X,@Uo)

    else
      @coci_en_tablero    = CortoCircuitoBifasicoBT.new( "Coci en Tablero",@alimentador.fase_aguas_arriba.R,@alimentador.fase_aguas_arriba.X,@Uo)
      @falla_en_tablero   = FallaATierraBifasica.new("Falla en Tablero",@alimentador.falla_aguas_arriba.Rfalla, @alimentador.falla_aguas_arriba.X,@Uo)
    end

    replace_or_encola_nodo(@coci_en_tablero)
    replace_or_encola_nodo(@falla_en_tablero)

    @envolvente = Envolvente.new("Tablero",1)
    replace_or_encola_nodo(@envolvente)
    @curva_D2                      = select_curva_D2
    @D2                            = select_D2(@curva_D2)
    #raise "D2 no es trifasico" if @D2.get_no_polos != 3
    #memoria.info "Ya se selección D2"
    replace_or_encola_nodo(@D2)
    #memoria.info "Ya se encoló D2"
 #   coleccion = @B3.get_coleccion if @B3
    memoria.info "Estoy antes de select_B3"
    @B3 = find_by_nombre("B3: Barra General en Tablero")
    memoria.info "Ya existe B3" if @B3
    coleccion = @B3.get_coleccion if @B3
    memoria.info "Hay #{coleccion.count} elementos en la colección de B3 antes de select_B3" if coleccion
    @B3                            = select_B3 unless @B3
#    @B3.coleccion                  = coleccion if coleccion
    memoria.info "Estoy despues de select B3"
    coleccion = @B3.coleccion
    memoria.info "Hay #{coleccion.count} elementos en la colección de B3 despuest de select_B3" if coleccion
    replace_or_encola_nodo(@B3)
    @alimentador.coci_maximo       = @coci_en_empalme
    @alimentador.coci_minimo       = @falla_en_tablero

    #ncadena_nodo(@D1,   @alimentador)

    replace_or_encola_nodo(@alimentador)


  end


  def nueva_linea(a_ccto,a_circuito,a_presupuesto)
  
    memoria.info "Estoy en nueva_linea de instalacion"
    memoria.info "Estoy en nueva linea, circuito es #{a_circuito.nombre}"
    memoria.info "  Dimensionando conductor de línea del circuito #{a_circuito.nombre}"
    ccto                   = a_ccto #Este es el circuito de Programación Orientada a Objeto que engloba todos los cálculos
    @circuito              = a_circuito #Este es el circuito de ActiveRecord el que representa el pedido del usuairo
    @presupuesto           = a_presupuesto #Este es el registro ActiveRecord que representa el pedido del suuario
    @cargas                = @circuito.cargas #Estas son las cargas que fueron ingresadas por el usuario

    

    @D3         = select_D3("D3: " + "#{ccto.nombre ? ccto.nombre : ccto.id.to_s}") #(@carga_equivalente_circuito)
    @D3.set_no_polos(@circuito.no_fases == 1 ? 2 : 3 )
    raise "No se setearon los polos en D3" unless @D3.get_no_polos > 0
    @linea      = Alimentador.new('Linea'+ @circuito.id.to_s)
    @linea.configurar( ccto.get_conductor.get_iz, ccto.get_largo, ccto.get_conductor.seccion,ccto.get_no_conductores, ccto.get_conductor.seccion,ccto.get_no_conductores, ccto.get_conductor.seccion,ccto.get_no_conductores,'Linea'+ @circuito.id.to_s,ccto)
    @B3 = find_by_nombre("B3: Barra General en Tablero")
    raise "No se ha encontrado barra en tablero" unless @B3

    #memoria.info @B3.get_coleccion.last.nombre if @B3.get_coleccion.last
    encadena_nodo(@B3, @D3)
    memoria.info "Se ha encadenado disyuntor a la barra"
    encadena_nodo(@D3, @linea)

    memoria.info "Se ha encadenado una línea al disyuntor"
    #memoria.info "Aguas abajo"
    #memoria.info @D3.aguas_abajo
    @B3<<@D3
    memoria.info "Se ha agregado un disyuntor a la barra, ahora hay #{@B3.coleccion.count} disyuntores"

    #memoria.info @B3.get_coleccion.first.aguas_abajo
    memoria.info "............"

    #memoria.info "Fases de circuito son: " + @circuito.no_fases.to_s
    if @circuito.no_fases > 1
      @falla_en_carga  = FallaATierraTrifasicaBT.new("Falla en la Carga",@linea.falla_aguas_arriba.Rfalla, @linea.falla_aguas_arriba.X,@Uo)
      @coci_en_carga   = CortoCircuitoTrifasicoSimetricoBT.new( "Coci en la Carga",@linea.fase_aguas_arriba.R,@linea.fase_aguas_arriba.X,@Uo)
    else
      @falla_en_carga  = FallaATierraBifasica.new("Falla en la Carga",@linea.falla_aguas_arriba.Rfalla, @linea.falla_aguas_arriba.X,@Uo)
      @coci_en_carga   = CortoCircuitoBifasicoBT.new( "Coci en la Carga",@linea.fase_aguas_arriba.R,@linea.fase_aguas_arriba.X,@Uo)
    end

    encadena_nodo(@linea,          @falla_en_carga)
    encadena_nodo(@falla_en_carga, @coci_en_carga)

    @linea.coci_maximo = @coci_en_tablero    
    @linea.coci_minimo = @falla_en_carga


                 #.coci_maximo.R = coci_tablero.R
    #             #.coci_maximo.X = coci_tablero.X
    #
    #memoria.info @B3.get_coleccion.first.aguas_abajo

    #Le asigna el coci del tablero a todos los disyuntores, porque el coci en tablero es el último en calcularse y es el mayor de todos
    memoria.info "Amononando los disyuntores en la colección de la barra"
    if @B3.get_coleccion and @B3.get_coleccion.count > 0

      @B3.get_coleccion.each do |disyuntor|
      
        memoria.info "Evaluando disyuntor de la barrra B3"
	disyuntor.aguas_abajo = find_by_nombre('Linea' + disyuntor.id.to_s)
	raise "No se encontró disyuntor aguas abajo de la barra  con el Nombre Linea" + disyuntor.id.to_s unless disyuntor

	disyuntor.aguas_abajo.coci_maximo.R =  @coci_en_tablero.R
	disyuntor.aguas_abajo.coci_maximo.X =  @coci_en_tablero.X
	memoria.info "Llamando a set_automatio para el disyuntor"
	disyuntor.set_automatico
	memoria.info "Volviendo de set_automatico"
      end
    end
  end
  

  def select_curva_D2
    #max es la curva más lenta escogida entre todas las cargas de ls instalacion 
    max  = @cargas.each.inject(@cargas.each.first){ |memo, carga| memo.get_n > carga.get_n ? memo : carga }

    @curva_mas_lenta = max.get_curva
    #raise "Curva más lenta #{@curva_mas_lenta} de todas las cargas"
    #CircuitoAlumbrado::CURVA es un arreglo de curvas válido para todos los circuitos de alumbrado y sus descendientes
    #@curva_D2 =CircuitoAlumbrado::CURVA.each.inject{|memo, curva| (max.get_n + curva[1]['minimo']) < (max.get_n + curva[1]['minimo']) ? memo : curva}
    @curva_D2 = @curva_mas_lenta
  end


  def instalacion_terminada?
    @instalacion_terminada
  end


  def select_D3(a_nombre)
   #a_nombre = "D3: Circuito ID: " + @circuito.id.to_s + " " + @circuito.nombre.truncate(10)
    c = @circuito.cargas 
    max = c.each.inject(c.each.first) { |memo, carga| memo.get_n > carga.get_n ? memo : carga }
    is = Is.new
    is<<@circuito
    @D3 = Disyuntor.new(is,is.get_max_is,is.get_fp,a_nombre,@stock,self.T,self.tension,1,self.regimen,max.get_curva,@circuito.id)
 
  end


  def get_curva_mas_lenta
    @curva_mas_lenta
  end


  def get_automatico_D1
    raise "D1 es nulo" unless @D1
    raise "D1.automatico es nulo" unless @D1.automatico
    @automatico = @D1.automatico if @D1
  end


  def get_automatico_D2
    @automatico = @D2.automatico if @D2
  end


  def select_D1(a_curva)
    #Para seleccona D1 no se considera la suma de cargas del circuito de tipo almentador usado para crear la acometida, sino que se usa la clase Is.
    memoria.info "Estoy en select_D1"

    ca = get_carga_equivalente
    memoria.info "Carga equivalente que ve el tablero :considera la suma de las corrientes aparentes #{get_carga_equivalente.get_i} A aparente"
    memoria.info "Iniciando la clase Is"
    is=D::Is.new
    memoria.info "Inyectando presupuesto a is"
    is<<@presupuesto
    memoria.info "is.para_vivienda es #{is.to_tipo_construccion}"

    memoria.info "T es #{self.T}"
    memoria.info "tension es #{self.tension}"
    memoria.info "regimen es #{self.regimen}"
    memoria.info "Ahora se creará un disyuntor para la is afectada por el tipo de construccion"
    memoria.info "is to tipo_construccion es #{is.to_tipo_construccion}"
    @D1 = Disyuntor.new(is,is.to_tipo_construccion,is.get_fp,'D1: Interruptor en Empalme',@stock,self.T,self.tension,1,self.regimen,a_curva)
    memoria.info "Saliendo de select_D1"
    
    return @D1
  
  end


  def get_carga_equivalente
      memoria.info "Hay #{@presupuesto.cargas.count} cargas en todo el presupuesto"
      
      carga0=@presupuesto.cargas.each.first.dup
      carga0.reset(@Uo)
      @carga_equivalente = @presupuesto.cargas.each.reduce(carga0,:+)

      memoria.debug @carga_equivalente.inspect
      #memoria.debug "Carga equivalente es de #{@carga_equivalente.get_i}"
      return @carga_equivalente
  end


  def get_potencia
  
    @potencia= Potencia.new
    @potencia << get_carga_equivalente
    return @potencia
  
  end
 

  def select_B3
    is=Is.new
    is<<@presupuesto
    n = Barra.new(is,is.to_tipo_construccion,is.get_fp,'B3: Barra General en Tablero',@barras,self.T,self.tension)
    n.set_no_polos(@no_polos)
    return n 
  end


  def select_D2(a_curva)
    memoria.info "Estoy en select_D2"
    is=Is.new
    is<<@presupuesto
    if @presupuesto.casa_habitacion
      @D2 = Disyuntor.new(is,is.to_tipo_construccion,is.get_fp,'D2: Automático General en Tablero',@stock,self.T,self.tension, 1, self.regimen,a_curva)
    elsif @presupuesto.local_comercial
      @D2 = Disyuntor.new(is,is.to_tipo_construccion,is.get_fp,'D2: Automático General en Tablero',@stock,self.T,self.tension, 1, self.regimen,a_curva)
    else
      @D2 = Disyuntor.new(is,is.to_tipo_construccion,is.get_fp,'D2: Automático General en Tablero',@stock,self.T,self.tension, 1, self.regimen,a_curva)

    end
    @D2.set_no_polos(@no_polos)
    #memoria.info "Saliendo de select_D2"
    return @D2
  
  end

  def get_barra_general
   @B3
  end

  def get_automatico_D3(a_id)
    b3=find_by_nombre('B3: Barra General en Tablero')
    if b3 and b3.get_coleccion
      b3.get_coleccion.each do |disyuntor|
	return disyuntor.automatico if disyuntor.id == a_id
      end
      #@automatico = @D3.automatico if @D3 
    end 
  end


  def tree

    memoria.info "Instalacion electrica: Tree"
    memoria.info ">>> #{@nombre} <<<"

    @nodos.each do |n|
     n.tree
    end
    memoria.info "End tree"
  
  end

  def set_automatico

    memoria.info "Instalacion electrica. Set automatico"
    memoria.info ">>> #{@nombre} <<<"

    @nodos.each do |n|
      n.set_automatico if n.respond_to?('set_automatico')
    end
    memoria.info "End Set automatico"


  end

  def calcula

    memoria.info "Instalacion electrica. Calcula"
    memoria.info ">>> #{@nombre} <<<"

    @nodos.each do |n|
      n.calcula if n.respond_to?('calcula')
    end
    memoria.info "End Calcula"
    return self
  end


  def puts
  
  # memoria.info "Instalacion electrica. Puts Anulado Para ahorrar tempo"
    memoria.info ">>> #{@nombre} <<<"
    @nodos.each do |n|
      memoria.info n.nombre
      n.puts
    end
    memoria.info "End Puts"
  
  end

  def no_polos=(a_no_polos)

    @no_polos = a_no_polos

  end

  def no_polos

    @no_polos 
  
  end

  def Uo=(a_Uo)

    @Uo = a_Uo

  end

  def Uo
  
    @Uo
  
  end


  def Un
  
    @Un
  
  end

=begin

  def dimensiona_legrand_original(a_ccto,a_circuito, a_presupuesto)

   @alimentador = @tramo_aereo

   if @no_polos > 1 #Esto está condicionado a los polos de l equipo de medida
      @coci_en_tablero    = CortoCircuitoTrifasicoSimetricoBT.new("Coci en Tablero", @alimentador.fase_aguas_arriba.R,@alimentador.fase_aguas_arriba.X)
      @falla_en_tablero   = FallaATierraTrifasicaBT.new("Falla en Tablero",@alimentador.falla_aguas_arriba.Rfalla, @alimentador.falla_aguas_arriba.X)
    else
      @coci_en_tablero    = CortoCircuitoBifasicoBT.new( "Coci en Tablero",@alimentador.fase_aguas_arriba.R,@alimentador.fase_aguas_arriba.X,@Uo)
      @falla_en_tablero   = FallaATierraBifasica.new("Falla en Tablero",@alimentador.falla_aguas_arriba.Rfalla, @alimentador.falla_aguas_arriba.X,@Uo)
    end

    is = Is.new
    is << a_circuito
    @D2 = Disyuntor.new(is,is.total,0.9,'D2: Automático General en Tablero',@stock,self.T,self.tension,0,self.regimen)
    @B3 = Barra.new(is,is.total,0.9,'B3: Barra General en Tablero',@barras,self.T,self.tension)

    @coci_en_tablero.aguas_arriba  = @alimentador
    @falla_en_tablero.aguas_arriba = @coci_en_tablero
    @D2.aguas_arriba               = @falla_en_tablero
    @B3.aguas_arriba               = @D2

        @alimentador.aguas_abajo     = @coci_en_tablero
        @coci_en_tablero.aguas_abajo = @falla_en_tablero
        @falla_en_tablero.aguas_abajo= @D2
        @D2.aguas_abajo              = @B3

        #@D2.aguas_abajo = @Barra
        #@Barra.aguas_abajo << @D3,@D3
            @alimentador.coci_maximo       = @coci_en_empalme
            @alimentador.coci_minimo       = @falla_en_tablero

    nodo =find_by_nombre('Tramo Aereo')
    if nodo
      replace_nodo(@alimentador,nodo)
    else
      encola_nodo(@alimentador)
    end

    nodo =find_by_nombre('Falla en Tablero')
    if nodo
      replace_nodo(@falla_en_tablero,nodo)
    else
      encola_nodo(@falla_en_tablero)
    end

    nodo =find_by_nombre('Coci en Tablero')
    if nodo
      replace_nodo(@coci_en_tablero,nodo)
    else
      encola_nodo(@coci_en_tablero)
    end

    nodo =find_by_nombre('D2: Automático General en Tablero')
    if nodo
      replace_nodo(@D2,nodo)
    else
      encola_nodo(@D2)
    end

    nodo =find_by_nombre('B3: Barra General en Tablero')
    if nodo
      replace_nodo(@B3,nodo)
    else
      encola_nodo(@B3)
    end

  end
=end

=begin
def dimensiona_legrand(a_ccto,a_circuito, a_presupuesto)
      @presupuesto = a_presupuesto
    @red           = EntradaTrafo.new(@Skq,@Un)
    encola_nodo(@red)
    @fuente        = SalidaTrafo.new(@Str,@Ucc,@Un)
    encola_nodo(@fuente)
      @trafo         = BuscaTrafo.new(@Str,Transformadores.new).trafo
      @trafo.dimensiona(@Un)

    encola_nodo(@trafo)

    forro_XTU      = Forro.find_by_id(11)
    ccto           = CircuitoIs.new(@trafo.In,forro_XTU)
    seccion        = ccto.get_conductor.seccion
    no_conductores = ccto.get_no_conductores
    iz             = ccto.get_conductor.get_iz * no_conductores
    #argo          = 5 #es un valor arbitrario para que coincida con al guia legrand
    largo=5 en ejemplo de guia de potencia legrand pagina 247 adobe pdf
    largo=30 en ejemplo de curso legran de evaluacion de cortocircuito pagina 64
   largo          = @presupuesto.largo

    @alimentador   = Alimentador.new(iz,largo, seccion,no_conductores, seccion,no_conductores, 95,1,'Alimentador',ccto) #La seccion de la tierra se calcula de otra forma, no con ccto. (todavia)



    #is << @presupuesto
    #@equipo_de_medida = EquipoMedida.new(is.para_vivienda, self.get_potencia.para_vivienda, 3,"Equipo de Medidas", @presupuesto, @empalmes)

    @coci_en_trafo         = CortoCircuitoTrifasicoSimetricoBT.new("Coci en Trafo", @fuente.fase_aguas_arriba.R, @fuente.fase_aguas_arriba.X,@Uo)


    encola_nodo(@coci_en_trafo)
    encola_nodo(@alimentador)

    @coci_en_tablero    = CortoCircuitoTrifasicoSimetricoBT.new("Coci en Tablero", @alimentador.fase_aguas_arriba.R,@alimentador.fase_aguas_arriba.X,@Uo)
    @falla_en_tablero   = FallaATierraTrifasicaBT.new("Falla en Tablero",@alimentador.falla_aguas_arriba.Rfalla, @alimentador.falla_aguas_arriba.X,@Uo)

    encola_nodo(@coci_en_tablero)
    encola_nodo(@falla_en_tablero)

    is=Is.new
    is << a_circuito
    @D2 = Disyuntor.new(is,is.total,0.9,'D2: Automático General en Tablero',@stock,self.T,self.tension,0,self.regimen)
    @B3 = Barra.new(is,is.total,0.9,'B3: Barra General en Tablero',@barras,self.T,self.tension)

    @envolvente = Envolvente.new('Tablero',3)

    encola_nodo(@envolvente)

    encola_nodo(@D2)
    encola_nodo(@B3)

    @alimentador.coci_maximo       = @coci_en_trafo
    @alimentador.coci_minimo       = @falla_en_tablero

  end
=end



end #finaliza la clase Instalacion
end
