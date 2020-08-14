#encoding: UTF-8
class Proteccion
  #Representa las características generales de los elementos de protección, algunos de los cuales no abren circuitos pero sí cumplen la función de disipar energía en caso de cortocircuitos, protegiendo al resto de los elementos. Ej repartidores

    def initialize(a_In,a_modelo,a_tension,a_formato,a_referencia="")
      @referencia = a_referencia
      @In = a_In
      @modelo = a_modelo
      @tension = a_tension
      @formato = a_formato
    end

    def to_param
      modelo
    end
    def referencia
      @referencia
    end

    def referencia=(a_referencia)
      @referencia = a_referencia
    end

    def get_tension
     @tension
    end

    def set_fp(a_fp)
     @fp=a_fp
    end

    def get_fp
      @fp
    end
    

    def get_curva_ipk(a_icc,a_in,a_usar_limitacion)
     # $logger.info "Estoy en get curva ipk"
     # $logger.info "icc " 
     # $logger.info a_icc.to_s
     # $logger.info "In"
     # $logger.info a_in.to_s
     # $logger.info "Usar limitación  " if a_usar_limitacion
     # $logger.info "Factor de Potencia "
     # $logger.info @fp
      #pagina 59 Gráfico de limitación DX3 Curso Legrand Protecciones Modulares
    raise "No está definido el factor de potencia para esta protección, revise que esté conectada a un alimentador a las cargas" unless @fp
      unless a_usar_limitacion
	fp = @fp
	if fp
	  intervalo = [0.25, 0.45 ,0.65,0.75,0.85,0.9,1]
	  cuantizado = intervalo.select{|i|  fp<=i}[0]
	  elevacion = {0.25 => 24, 0.45 =>  11,  0.65 =>  7,  0.75 => 4.5,  0.85 => 2.4,  0.9=> 1.4}
          elevacion = {0.45 => 24, 0.65 =>  11,  0.75 =>  7,  0.85 => 4.5,  0.9 => 2.4,  1 => 1.4}

	  seleccionados = intervalo.select{|i|  fp<=i}
	  pendiente = 1.98
#	  $logger.info "Estoy en no usar limitación de get_curva_ipk"
#	  $logger.info "cuantizado"
#	  $logger.info  cuantizado
#	  $logger.info "Seleccionado"
#	  $logger.info seleccionados[0].to_s
#	  $logger.info "elevacion"
#	  $logger.info elevacion[cuantizado]
#	  $logger.info "pendiente"
#	  $logger.info  pendiente
#	  $logger.info "icc"
#	  $logger.info a_icc
	  return elevacion[cuantizado] +( pendiente * a_icc)
	end
      else
	if (a_in >= 80 and a_in <= 125)
	  intervalo_icc = [10, 80]
	  pendiente     = {10 => 0.66, 80 => 0.25}
	  elevacion     = {10 => 1.4,  80 => 7   }
	else
	  intervalo_icc  = [25, 80]
	  pendiente      = {25 => 0.45, 80 => 0}
	  elevacion      = {25 => 1.4 , 80 => 12}
	end
		
	key = intervalo_icc.select{|i| a_icc <= i}[0]
	value = elevacion[key] + (pendiente[key] * a_icc)

	return value
      end
    end

    def get_fp_cuantizada
      raise "No está definido el factor de potencia para esta protección, revise que esté conectada a un alimentador a las cargas" unless @fp
      fp = @fp
      if fp
	intervalo = [0.7,0.5,0.3,0.25,0.2]
	seleccionados = intervalo.select{|i|  fp>i}
	return seleccionados[0]
      end
    end

    def get_ipk(a_modelo,a_icc_maxima)

       #Oágina 178 n Catalog General 2016 2017 Kegrand
      
       drx_modelos=["DRX 125", "DRX 250", "DRX 630"]

       drx_ipk=[2,3,5]
       ipk = drx_modelos.each_with_index{ |m, index|    return  drx_ipk[index]  if a_modelo.include?(m)}
 
 #Oágina 74 en Catalog General 2016 2017 Kegrand

       dpx_modelos=["DPX 250","DPX-H 250","DPX 630","DPX-H 630","DPX 1600","DPX-H 1600"]

       dpx_ipk=[27,34,34,42, 85,110]
       ipk = dpx_modelos.each_with_index{ |m, index| 	return dpx_ipk[index]  if a_modelo.include?(m)}

    end

    def cumple_Ipk?(a_icc_maxima,a_in, a_modelo)
      
      case a_modelo

      when /^\s*(DRX)\b[^_]/
	ipk  = get_curva_ipk(a_icc_maxima,a_in,true)

      when /^\s*(DX3)\b[^_]/
	ipk  = get_curva_ipk(a_icc_maxima,a_in,true)

      when /^\s*(DPX 250|DPX-H 250|DPX 630|DPX-H 630|DPX 1600|DPX-H 1600)\b[^_]/
	#aise "Es DPX"
	ipk  = get_ipk(a_modelo,a_icc_maxima)
#raise "Es #{a_modelo} icc_maxima es #{icc_maxima} ipk = #{ipk}"
      else
	ipk = get_curva_ipk(a_icc_maxima,a_in,false)
      end
  
      ipk_limitado    = get_curva_ipk(a_icc_maxima,a_in,true)
      ipk_no_limitado = get_curva_ipk(a_icc_maxima,a_in,false)
=begin
      $logger.info "            En Repartidor, evaluando ipk debido a icc_maxima:"
      $logger.info "               Ipk admisible = #{@Ipk.round(1)} kA"
      $logger.info "               Ipk no limitado = #{ipk_no_limitado.round(1)} kA"
      $logger.info "               Ipk limitado = #{ipk_limitado.round(1)} kA"
      $logger.info "               icc_maxima= #{a_icc_maxima.round(1)} kA -> ipk limitado= #{ipk.round(1)} kA." 
      $logger.info "               Ipk admisible = #{@Ipk.round(1)} kA  > ipk = #{ipk.round(1)} kA." if @Ipk > ipk
      $logger.info "               Ipk admisible = #{@Ipk.round(1)} kA  < ipk = #{ipk.round(1)} kA." if @Ipk < ipk
      return @Ipk >= ipk
=end
    end

    def set_Ue(a_Ue)
      #Ue es tensión asignada de empleo
      #pag 288 de Guia de Potencia
      #Catalogo General Legrand 2016 2017
      #
      #Tensión máxima de utilización (50/60 Hz) Ue (V) catalaogo Legrand 2017 paga 74
      #Catalogo General Legrand 2016 2017
      if check_Ue(a_Ue)
	@Ue= a_Ue
	#@voltaje= a_Ue #ojo
	return true
      end
    end

    def check_Ue(a_Ue)
      if self.modelo.include?("DRX")
       #pag 74 de guia de potencia

	if get_tension >= 110 and get_tension <= 113 
	  return true        
	end

	if get_tension >= 220 and get_tension <= 240
	  return true 
	end

	if get_tension >= 380 and get_tension <= 415
	  return true 
	end

	if get_tension >= 440 and get_tension <= 460
	  return true 
	end

	if get_tension >= 480 and get_tension <= 550
	  return true 
	end

	if get_tension == 600
	  return true 
	end

      elsif self.modelo.include?("DPX3 160")
	return true if a_Ue >= 220 and a_Ue <= 240
	return true if a_Ue >= 380 and a_Ue <= 415
	return true if a_Ue == 440
	return true if a_Ue >= 480 and a_Ue <= 500
	return true if a_Ue == 690
      else
	if get_tension >= 220 and get_tension <= 240
	  return true if a_Ue >= 220 and a_Ue <= 240
	end

	if get_tension >= 380 and get_tension <= 415
	  return true if a_Ue >= 380 and a_Ue <= 415
	end

	if get_tension == 440
	  return true if a_Ue ==440
	end

	if get_tension >= 480 and get_tension <= 500
	  return true if a_Ue >= 480 and a_Ue <= 500
	end

	if get_tension == 690
	  return true if a_Ue == 690
	end

      end
    end


    def precio=(a_precio)
      @precio = a_precio
    end

    def precio
      @precio
    end

    def referencia=(a_referencia)
      #Está ordenado por polos.
      #Debe obtenerse la referencia como 
      #referencia[polos] onde polos es la cantidad de polos que se haya determinado en la instalación de acuerdo al lugar donde se insertó el disyuntor.
      @referencia=a_referencia
    end

    def referencia
      @referencia
    end
 
    def no_fases
      #se refiere al tipo de circuito donde está instalado. Hay circuitos trifásicos, con tres fases, que requiereon 3 polos o cuatros polos. Con cuatro polos se puede controlar las 3 fases y el neutro. Hay circuitos monofásicos con 1 fase que se puede cortar, se usa con un polo. El mismo circuito que tiene una fase puede requerir que se corte tambíén el neutro, con lo que se necesitarían protecciones con dos polos. Estos dos polos se pueden comprimir en protecciones donde se corta el neutro y la fase usando el espacio de un módulo y esto se denomina 1F + N. Por ùltimo, puede haber circuitos que se alimentan con tension de más de 220, lo que se requiere para algunos motores, con lo que se usan dos fases para subir el voltaje. Estos circuitos pueden ser controlados con dos polos, que corresponderían a  dos fases.
      @no_fases
    end

    def set_polos(a_polos)
      #$logger.info "Se ha fijado el número de polos a #{a_polos}"
      @polos=a_polos
      case @polos
      when 3
	@tres_polos = true
      when 2
	@dos_polos = true
      when 1
	@un_polo = true
      when 1.5
	@uno_y_medio_polo = true
      when 4
	@cuatro_polos = true
      end
      return true
    end

    def polos
      @polos
      #Esto sirve para reservar espacio en el tablero.
      #Los polos pueden incluir el neutro
    end

    def tres_polos=(tres_polos)
      @tres_polos=true
    end

    def cuatro_polos=(cuatro_polos)
      @cuatro_polos=true
    end

    def dos_polos=(dos_polos)
      @dos_polos=true
    end

    def un_polo=(un_polo)
      @un_polo=true
    end

    def uno_y_medio_polo=(uno_y_medio_polo)
      @uno_y_medio_polo=true
    end

    def montaje
      @montaje
    end

    def Is=(a_is)
      @Is=a_is
    end

    def Iz=(a_iz)
      @Iz=a_iz
    end

    def voltaje=(a_voltaje)
      @voltaje=a_voltaje
    end

    def voltaje
      @voltaje
    end

    def Uimp
      #Valor en kV que caracteriza la aptitud del aparato para resistir sobretensiones transitorias debido al rayo
      #Se prueba con onda normalizada 1,2/50 microsegundos, En algunos casos se denomina choque, en otros impulso
      #Pagina 35 curso Protecciones Caja Moldeada
    end

    def standard
      @standard
    end

    def Ui
      #Pagina 34 curso Legran Protecciones Caja Moldeada
      #t
      #Tensión de aislamiento, Determina las tensiones de prueba dieléctrica (onda de choque, frecuencia industrial)
    end

    def tension
      @tension
    end

    def T
      @T
    end

    def nombre
      @nombre
    end
    
    def In
      @In
    end
  
    def calibre
      @In
    end

    def soporta_activacion_bajo_cortorcuito?

    end

    def modelo
      "DRX- Son disyuntores fijos para carga invariable"
      "DPX3- Carga es permanentemente modificada para para necesidades del proceso o cambio en el largo de los conductores"
      "DPX3 630/1600. Uso como protección general en tableros de distribución"
      "DX3 es lo mismo que DX"
      "DMX Se usan en celdas"
      return @modelo
    end

    def cumple_T(a_T)
      #$logger.info "Evaluando T #{self.T} con #{a_T}"
      if  self.T >= a_T
	return true
      else
	return false
      end
    end

    def formato
      @formato
    end


    def Icw #en kA
      #pagina 52 Protecciones caja Moldeada
      #Corriente de cortocirucito que soportan los interruptores categoría B durante un período de tiempo sin que sus características se alteren. Entiendo que esto es necesario porque la selectiva cronométrica exigirá al interruptor que se mantenga firme ante una corriente de cortoricuito aguas abajo el tiempo suficiente para garantizar que se abra el interruptor aguas abjao.
      #pagina 48 Protecciones caja Moldeada
      #solo para la categoría B
      #Poseen una temporización regulable para permitir la selectividad cronométrica con cortocircuitos inferiores a Icw
      if self.respond_to?('categoria') and self.categoria == "B"
	 return 12*self.In if self.In <= 2500
	 return 30 if self.In > 2500
      else
	@Icw
      end
    end
 
    def tree
	$logger.info "         |"
	$logger.info "         #{@nombre}"
	$logger.info "         |"
    end

    def puts
	$logger.info ""
	$logger.info "=============================="
	$logger.info "Proteccion #{@nombre}=========="
	$logger.info "   Debe funcionar a una temperatura de #{@T} ºC"
    end

  end

