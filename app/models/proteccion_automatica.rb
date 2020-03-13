#ncoding: UTF-8
#Esta clase engloba la funcionalidad de un automático a fin de que se pueda seleccionar aquel que sea capaz de aplacar con solvencia los arcos eléctricos originados por fallas.
#
  class ProteccionAutomatica < Proteccion

    def initialize(a_poder_de_corte, a_In, a_modelo,a_voltaje,a_formato)
      super(a_In,a_modelo,a_voltaje,a_formato)
      @clase1 = LimitacionTermica.new(1, nil)
      @clase2 = LimitacionTermica.new(2, 160000)
      @clase3 = LimitacionTermica.new(3, 55000)
      @PdC    = a_poder_de_corte
    end

    def es_selectivo?(a_disyuntor_aguas_arriba)
      upper = a_disyuntor_aguas_arriba
      return true unless upper

      if upper and upper.automatico
        backup = upper.automatico
      else
	return true
      end

      #$logger.info "Evaluando selectividad de #{backup.modelo} aguas arriba y de #{modelo} aguas abajo"

      if backup.modelo.include?("DPX3") and modelo.include?("DX3")
         true
      elsif backup.modelo.include?("DX3") and modelo.include?("DX3")
         true  if backup.In > self.In and backup.Im > self.Im
      elsif backup.modelo.include?("DX3") and modelo.include?("DPX3")
	 true
      elsif backup.modelo.include?("DX3") and modelo.include?("DPX")
	 true
      elsif backup.modelo.include?("DPX3") and modelo.include?("DPX3")
	 true
      elsif backup.modelo.include?("DPX3") and modelo.include?("DPX")
	 true
      elsif backup.modelo.include?("DPX") and modelo.include?("DPX3")
	 true
      end
      
    end


    def get_Im
      return @Im
    end

    def get_Ir
      return @Ir
    end

    def get_regulacion
      return @regulacion
    end

    def cumple_Ir?
       self.Ir
       return true
    end


    def Im_minima
      return @Im_minima
    end

    def Im_maxima
      return @Im_maxima
    end

    def cumple_pdc?(icc_maxima)
      if self.pdc and self.pdc >= icc_maxima      
        #$logger.info "#{self.modelo} con PdC #{self.pdc}  ? iccmax #{icc_maxima.round(0)} kA"	
      end
      return true if self.pdc and self.pdc > icc_maxima
    end

    def PdC
      return @PdC
    end
    
    def Icu
      #pagina 38
      #Poder de corte último (kA eficaces) Es lo que se mide, no corresponde al valor peak de la onda
      #
      #pagina 11 de curso Legrand Protecciones Caja Moldeada
      #Corriente de cortocircuito ultimo"
      #pagina 37 Protecciones Caja Moldeada
      #Valor máximo de corriente de cortocircuito que puede cortar una automático bajo una tensión y un desfase (cos(phi)) determinados
      #Se realiza una prueba O - t - CO
      #Maniobra de apertura - espera - Maniobra de cierre seguida de una maniobra de apertura automática
      #g 288 Guia de Diseño
      #La capacidad de corte nominal (Icu o Icn) es la corriente de defecto máxima que un interruptor auutomatíco puede interrumpir satisfactoriamente sin sufrir daños
      #La corriente de esta magnitud ocurre con muy poca probabilidad. . En condiciones normales las corrientes de defecto son bastante menores que la capacidad de corte nominal.
      #Por otro lado, es importante que aún en el caso de que ocurran con poca probabilidad, las corrientes de falla se interrumpan en condiciones adecuadas con el fin de que el interruptor esté disponbile de inmediato para volver a conectarse una vez reparado el cirucito defectuoso. Para ello se define una nueva característica que se expres como un porcentaje de Icu, para interruptores de uso industrial.
      #La secuencia de prueba es A-CA-CA (a Ics)
      #Las pruebas que siguen a esta, tienen como objetivo verificar que el interruptor auomático esté en perfecto estado de funcionamiento y disponible para presatar un funcionamiento normal.

      #
      if self.modelo.include?("DPX3 160") 
        raise "No está definido @Ue para este automático #{self.modelo}" unless @Ue
        if get_tension >= 220 and get_tension <= 240
          return 25
        elsif get_tension >= 380 and get_tension <= 415
          return 16
        elsif get_tension == 440
          return 10
        elsif get_tension >= 480 and get_tension <= 500
          return 8
        elsif get_tension == 690
          return 5
	end
      elsif self.modelo.include?("DRX")
	#La tabla no esta completa ver pag 74 (40 en papel) de Catalogo General Legrand 2016-2017
	      icus ={125 => {130 => { 20 => 75, 25 =>  50, 36 => 100},
                             240 => { 20 => 40, 25 =>  25, 36 => 100}, 
	                     415 => { 20 => 20, 25 =>  10, 36 =>  36},
		             460 => { 20 => 15, 25 => nil, 36 =>  30},
		             550 => { 20 => 10, 25 => nil, 36 =>  20},
		             600 => { 20 =>  5, 25 => nil, 36 =>  10}},
                      250=> {130 => {           25 =>  60, 36 =>  85},
                             240 => {           25 =>  50, 36 =>  65},
                             415 => {           25 =>  25, 36 =>  36},
                             460 => {           25 =>  25, 36 =>  30},
                             550 => {           25 =>  15, 36 =>  20},
                             600 => {           25 =>  10, 36 =>  12}},
                      630=> {240 => {                      36 =>  65, 50 => 100},
                             415 => {                      36 =>  36, 50 =>  50},
                             460 => {                      36 =>  30, 50 =>  40},
                             550 => {                      36 =>  25, 50 =>  30}}}




                intervalos_voltaje = [130,240,415,460,550,600]
                voltaje = self.get_tension
                voltaje_cuantizado = intervalos_voltaje.select{|v|  voltaje <= v}[0]

	begin
	  return icus[gama][voltaje_cuantizado][pdc]
	rescue
	  #dc = 20
	  #alibre = 15
	  #voltaje cuantizado = 240
	  #
          raise self.inspect
	end
      else
        return self.pdc
      end
    end

    def Ics
      if self.modelo.include?("DPX3") 
	if self.montaje.include?("Fijo") and self.formato == "Caja Moldeada" and self.Icu
          return self.Icu/2
	else
	  return self.Icu 
	end
      end
      #pagina 11 curso Legrand Protecciones Caja Moldeada
      #Corriente de cortoricuito de servicio
      #

      if self.modelo.include?("DRX")
        return self.Icu/2
      end
    end

    def recomendado_como_seccionador #como aislante pag 74 catalgo 2015
     true if self.modelo.include?("DRX") 
    end

    def pdc      
      return @PdC.industrial if self.industrial and !@PdC.industrial.nil?
      return @PdC.domiciliario/1000 if self.domiciliario and !@PdC.domiciliario.nil?
      #$logger.info "Estoy en pdc de automatico"
      #$logger.info "Es industrial " if self.industrial
      #$logger.info "Es domiciliario " if self.domiciliario


      #$logger.info @PdC.industrial.to_s
      #$logger.info @PdC.domiciliario.to_s

      return 0
    end

    def lr #A#pasos de 1A
      #Umbral lr A
      #Protección de retardo largo contra sobrecargas
      return [0.4,1]*self.In if self.principio == "Electrónico" and self.tecnologia == "Caja Moldeada"  and (self.modelo.include?("DPX3 250"))
      # or self.modelo.include?("DPX3 630") or self.modelo.include?("DPX3 1200")) 
    end

    def Tr #s
      #Tiempo de respuesta Tr(s)
      #Proteccion de retadro largo contra sobrecargas
      return [3,16] if self.principio == "Electrónico" and self.tecnologia == "Caja Moldeada"  and (self.modelo.include?("DPX3 250"))
    end


    def lsd #A
      #Umbral lr A
      #Protección de retardo corto contra cortocircuitos
      return [1.5,10]*self.In if self.principio == "Electrónico" and self.tecnologia == "Caja Moldeada"  and (self.modelo.include?("DPX3 250"))
      # or self.modelo.include?("DPX3 630") or self.modelo.include?("DPX3 1200"))
    end

    def Tsd #ms
      #Tiempo de respuesta Tsd(ms)
      #Protección de retardo corto contra cortocircuitos
      return [0,0.5] if self.principio == "Electrónico" and self.tecnologia == "Caja Moldeada"  and (self.modelo.include?("DPX3 250"))
      #PAra I=K o I2t=K es igual
    end

    def lg #A
      #Umbral lg A
      #Protección contra fallas de tierra (bajo demanda)
      return [0.2,7]*self.In if self.principio == "Electrónico" and self.tecnologia == "Caja Moldeada"  and (self.modelo.include?("DPX3 250"))
      # or self.modelo.include?("DPX3 630") or self.modelo.include?("DPX3 1200"))
    end

    def Tg #s
      #Tiempo de respuesta Tr(s)
      #Proteccion contra fallas de tierra (bajo demanda)
      return [0.1,1] if self.principio == "Electrónico" and self.tecnologia == "Caja Moldeada"  and (self.modelo.include?("DPX3 250"))
    end

    def In
      #Valor maximo de corriente que el interruptor puede soportar de manera permanente. Pero debe fijarse una temperatura dada
      return @In
    end

    def cumple_ICM?(a_icc_pk)
     
    end

    def ICM
     #Poder de Cierre Asignado bajo Cortocircuito
     #Es la mayor intensidad de corriente que un aparato puede conectar cuando cierre con un cortocircuito en la salida dbajo la tensión asignada según las conddiciones de la norma
      #
      case get_fp_cuantizada
      when 0.7
	return 1.5 * self.Icu
      when 0.5
	return 1.7 * self.Icu
      when 0.3 
	return 2.0 * self.Icu
      when 0.25
	return 2.1 * self.Icu
      when 0.2
	return 0.20 * self.Icu
      end
      
    end

    def cumple_ICM?(a_icc_pk)
      #Icc_pk está relacionada con el la 
      #pagina 38 Curso Legrand Protecciones Caja Moldeada
      return true if self.ICM >= a_icc_pk
    end

    def Inf
      unless self.industrial
        return (self.In*1.13).round(1)
      else
        return (self.In*1.05).round(1)
      end
    end

    def t_op_f #tiempo de disparo convencional para cuando i esté entre Ifn e If

      if self.In <= 63
        return 1 #@hora
      else
        return 2 #horass
      end
    end

    def If
      unless self.industrial
        return (self.In*1.45).round(1)
      else
        return (self.In*1.3).round(1)
      end
    end


    def Ir
      case curva
       when 'MA'
	 @Ir = nil
         return nil

       else
	 @Ir = @In
         return @In
       end
    end

    def limitacion
     if self.In <= 40 and @domiciliario
      return  @clase3
     end
     if self.modelo.to_s.include?("DX3")
       return @clase3
       #pagina 7. curo legradn de proteccione modulares
     end
    end

    def set_industrial
      @standard = "60947-2"
=begin
      "Tipo de usuario calificado"
      "Interruptores automáticos, aplicación industrial"
      "50 o 60Hz"
      "En alterna: Tensión entre fases no superior a 1000"
      "En continua: No superior a 1500V"
      "Categoría A y B"
      "Caja Abierto - Caja Moldeada"
      "Instalación Fijo, Enchufable, Extraíble"
      "In no superior a 125A"
      "PdC no superior a 25KA"
=end
      @industrial=true
      @domiciliario=false
      return true
    end

    def industrial
      return @industrial
    end

    def set_domiciliario

=begin
      "Tipo de usuario no calificado"
      "Disyuntores pequeños, uso doméstico"
      "50 o 60Hz"
      "Tensión entre fases no superior a 400"
      "In no superior a 125A"
      "PdC no superior a 25KA"
=end

      @standard = "60898-1"
      @domiciliario=true
      @industrial = false
      return true
    end

    def tc #tiempo de condución en ns
      return 1 if self.formato.to_s.include?("Caja Moldeada")
    end

    def no_polos
      if self.modelo.include?("DRX")  
        return 3 if self.pdc == 20 and self.pdc==36
        return 1 if self.pdc == 25
      else
        @no_polos
      end
    end

    def Ue #Tension maxima de utilizacion
      #ensión de uso <= Ui
     return 550 if self.modelo.include?("DRX 125")
     return 600 if self.modelo.include?("DRX 250")
     return 600 if self.modelo.include?("DRX 630")
    end

    def Ui
     #tensión nominal de aislamiento. Se usa para evaluar experimentos de conectar y desconectar
      #El valor máximo de la tesión operativa funcional nominal nunca debe ser superior a la tensión de islmaiento
     if self.modelo.include?("DRX")
      return 690 
     else
      return @Ui
     end

    end

    def asociacion
     #if pdc > iccmax
      #else
      #pdc combinada > iccmax
    end

    def selectividad
      #La selectividad entre los interruptores automaticos A y B es total si el valor maximo de la corriente de ortocircuito en el ciruioc B no supr el ajuste de disparo por cortocircuito del interruptor auomatico A. E esta condición solo disparará el ainterruptor autoamtico B.
      #Pas selectividad es parical si la maxim acorriente de cortociruicto posilbn en el circuito B es superior al ajsute de la correiente de siapro por cortocirucito del interruptor autoamtic A. En esta condicion disapararan los interruptores autoamticos a yyB.
      #Por reglas general la selectividad se consgie cuando ;
      #Ira/IrB > 2
      #ImA/ImB > 2  el limite de selectivida es ImA
    end

    def limitacion_de_sobretension

      #Se recomienda en el origen de la isntalacion si la alimentacion proviene de una línea aerea.
    end

    def Icm
      #Es el valor instantaneo de corriente más alto que un interruptor puede establecer a la tension nominal en las condiciones especificiadas. Está relaciona con Icu. (Icu es rms, Icm es instantáneo)
    end

    def Icw
      #pag 288 Guia
      #Es la corriente máxima que puede resistir el interrupor de categoría B, térmica y electrodinamicamente, sin sufrir daños duante un período indicado por el fabricante
    end


   def categoria
      #categoría de utilización según pag 288 Guia de Diseño de Isntalaciones Electricas
      #A (disparo instantáneo)
      #No existe un retardo deliberado en el funcionamiento del dispositivo de disparo magnético por cortoricuito "instantaneo", son, en general, circuitos automáticos de caja moldeada.

      #B (disparo con retardo)
      #Es posible retrarse el disparo del interruptor automático, donde el nivel de corriente por defecto es menor que el valor nomnal de la corriente de resistencia de corta duraicón Icw.Esto se aplica generalmente a dispositivos de gran resistencia con caja moldeada.
      #caterogia de uso,
      #También se usa categgoriía de empleen en el caso de los interruptores accionadores
      #puedne ser AC 23A para estandar IEC 60947-3 o AC 22A para la misma norma
      if modelo.include?("DPX3")
        if modelo.include?("160") or modelo.include?("250")
          return "A"
        end
      end

      if self.modelo.include?("DRX")
        return "A"
      end

      if self.formato.to_s.include?("Caja Moldeada")
        if self.principio == "Magneto Térmico"
          return "A"
        elsif self.principio == "Electrónico"
          #Puede hacer selectividad cronométrica
          #Pagina 9 curso Legrand Protecciones Caja Moldeada
          return "B"
        end
     end
    end

    def T
      return 30 if @domiciliario
      return 40 if @industrial
      #Temperatura a la que el interruptor puede soportar In en forma permanente
    end

    def domiciliario=(a_domiciliario)
      @domiciliario = a_domiciliario
    end

    def industrial=(a_industrial)
      @industrial = a_industrial
    end

    def domiciliario
      return @domiciliario
    end

    def minima_regulacion_del_termico_per_design
      return nil
    end


  end
