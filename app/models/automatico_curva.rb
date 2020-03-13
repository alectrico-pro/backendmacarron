#encoding: UTF-8
#Caracteriza a las protecciones modulares
#Caracteriza un automatico cuyas propiedades de protección principales se expresar por su pertenencia a determinadas curvas en un gráfico de respuesta de valor de corriente de fallas v.s. tiempo. La curva representa el umbral de disparo en función de la magnitud de la corriente de falla y del tiempo que puede soportarla.
  class AutomaticoCurva < ProteccionAutomatica
    MARGEN = 1

   def to_json(*a)
      data = {
               'calibre'       => @In,
               'modelo'        => @modelo,
               'curva'         => @curva,
               'modulo_por_polo'=> @modulo_por_polo,
               'caja'          => @formato,
               'voltaje'       => @tension,
	       'domiciliario'  => @domiciliario,
	       'industrial'    => @industrial,
	       'polos'         => @polos

             }

      {
        'json_class' => self.class.name,
        'data'       => data.to_json(*a),
	'pdc'        => @PdC.to_json,
	'referencia' => @referencia.to_json,
        'precio'     => @precio.to_json
      }
    end

    def self.json_create(o)
      referencia    = JSON.parse(o['referencia']) if referencia
      precio         = JSON.parse(o['precio'])  if precio
      pdc            = PdC.json_create(o['pdc'])

      attrs          = JSON.parse(o['data'])
      n              = AutomaticoCurva.new(pdc, attrs['calibre'].to_i,attrs['modelo'],attrs['curva'],attrs['modulo_por_polo'].to_i,attrs['caja'],attrs['voltaje'].to_i)
      n.domiciliario = attrs['domiciliario']
      n.industrial   = attrs['industrial']
      n.referencia   = referencia
      n.precio       = precio
      n.set_polos(attrs['polos'] )
      return n
    end

    def industrial=(a_industrial)
      @industrial = a_industrial
    end

    def domiciliario=(a_domiciliario)
      @domiciliario = a_domiciliario
    end

    def regulacion
      #Los automáticos de curva no poseen regulación alguna: son fijos
      return 0
    end

    def Iz
      #Esta es la corriente máxima admisible del conductor (o condutores) que ve la protección aguas abajo
      return @Iz
    end

    def Is
      #Esta es la corriente de salida que debe atender esta protección, está definida por la totalidad de las corrientes que demanda cada carga
      return @Is
    end

    def principio
      #Los automáticos de curva solo operan con un par bimetálico sensible al calor que se acumula con el paso de la corriente. También poseen un elemento magnético que opera en cuestión de nanosegundos cuando la corriente se eleve al rango de la curva, en su umbral magnético de disparo, denominado corriente magnética. 
      #El umbral magnético es relativo porque no se puede garantizar un valor exacto en cada pieza producida por eso cada curva de funcionamiento es en realidad una abstracción de una familia de curvas que podrían estar entre rangos mínimos y máximos de corriente de disparo magnético.
      #Para homogenizar las curvas, se las expresa en función de la corriente nominal de la protección. El que es el valor de referencia que se usa para seleccionarlo al comparar In con Is. Es posible que en Is sea momentáneamente superior a In. Está previstos que sea de 1 hora en caso de protecciones domésticas y de 2 horas en el caso de protecciones industriales.
      return "Magnético Térmico"
    end


    def initialize(poder_de_corte, calibre, modelo,curva, modulo_por_polo,caja, voltaje = 220)
      raise "Debe ingresar una tensión para esta proteccion " unless voltaje
      super(poder_de_corte, calibre, modelo,voltaje,caja)
      @modulo_por_polo=modulo_por_polo
      @curva = curva
     
      case @curva
        when 'D'
          @Im_minima = 2.36*@In
          @Im_maxima_domiciliaria = 2.4*@In
          @Im_maxima_industrial =2.4*@In


	when 'B'
          @Im_minima = 3*@In	
	  @Im_maxima_domiciliaria = 5 *@In
          @Im_maxima_industrial =5*@In

	when 'C'
	  @Im_minima = 5*@In
	  @Im_maxima_domiciliaria = 10*@In
	  @Im_maxima_industrial =10*@In


	when 'D'
	  @Im_minima = 10*@In
          @Im_maxima_industrial = 20*@In

	  @Im_maxima_domiciliaria  = 14*@In

	when 'MA'
	  @Im_minima = 12*@In
	  @Im_maxima_domiciliaria = 14*@In
          @Im_maxima_industrial =14*@In
	else 
	  raise "No se ingresó una curva en #{modelo} #{calibre}"
	end


    end
  
    #El montaje puede ser en riel on en placa 
    def montaje
      unless @montaje.nil? 
        return @montaje
      else
        return "Perfil"
      end
    end 

    #La cantidad de modulos por cada polo
    #Esta relacionado con el espacio que se requiere en el tablero (modulo).
    def modulo_por_polo
      return @modulo_por_polo
    end

    #La curva
    def curva
      return @curva
    end

    def cumple_In?(a_is,a_iz)
      #Esta es la regla principal de selección de una protección definida por sus curvas. Se define para la protección por sobreconsumo con el fin de evitar el recalmentamiento de los conductores que tiene conectados. Dado que la protección tiene como objetivo final la protección de los conductores, no de las cargas.
     # $logger.info "#{self.modelo} cumple_In( #{a_is},#{a_iz}) In= #{@In} Iz*margen #{a_iz * MARGEN} #{( @In >= a_is and @In <= a_iz*MARGEN) ? 'cumple In': 'no cumple In'}"
      @Is=a_is
      @Iz=a_iz
      if (@In >= a_is and @In <= a_iz * MARGEN )
	return true
      else
	return false
      end
    end

    #Si acaso cumple o no con el disparo magnetico que se necesita en el circuito
    #Ya está traducida el tipo de curva a parámetros de Imaxima, pero no si las cargas exigen una curva esta debe ser mayor que esta im.
    #La corriente del magnético es la que se usa para garantizar selectividad.
    def cumple_Im?(im_maxima,regimen)
      return true if regimen == "TT"
      if self.Im_maxima.nil?

       $logger.debug @domiciliario
       $logger.debug @industrial
       $logger.debug @Im_industrial
       raise "Error: Im maxima no pudo ser estimada para el automatico #{self.modelo} #{@curva} #{@In}"
      else
       return true if self.Im_maxima < im_maxima
      end

    end

    def cumple_curva?(a_curva)
      #Esta verificación busca complacer a las cargas complicadas que no son complemtamente resistivas, esas adolecen de un desfasaje entre la corriente y el voltajes que puede hacer que una protección de curva rápida se dispare innecesariamente. Otras cargas como los motores tienen una corriente diferente durante la partida y otra para el tiempo de funcionamiento. Hay otras que alteran la forma de onda como las fuentes conmutadas lo que presenta otros desafíos. 
      #Para cada tipo de carga hay definida una curva, que debe ser respetada en paralelo con el cumplimiento de la corriente del magnético.
      #$logger.info "cumple curva con #{a_curva}"
      #$logger.info "@curva es #{@curva}"
      #return true
      #$logger.info "cumple curva" if @curva == a_curva
      @curva == a_curva
     #  self.curva >= a_curva
    end

    def Im
      #Valor de disparo magnético, es la magnitud de corriente que hará disparar al elemento de protección magnético. Es un alias para Im_maxima
      self.Im_maxima
    end

    alias_method :get_Im, :Im

    def Im_maxima
     #Valor de disparo magnético. Se define de acuerdo al tipo de protección: caso industrial o domiciliaria.
      #De acuerdo al tipo de usuario se toma un resguardo mayor o menor aunque el dispositivo sea el mismo. Se puede asumir que es una mentira piadosa. Pero hay un problema serio y es que una protección puede alterar su comportamiento de disparo si es usuada en forma abusiva por un usuario residencial, llevando a que el disparo magnético sea más lento. Esto ocurre porque el usuario intentará realizar maniobras de reconexión en caliente mientras hay un cortocircuito declarado.
     return @Im_maxima_industrial if self.industrial
     return @Im_maxima_domiciliaria if self.domiciliario
    end
     
    def Im_minima
      #Corriente de disparo magnético mínimo. Es el umbral magnético a que se dispara la protección que se haya fabricado con mayor sensibilidad (depende de las condiciones concretas de su fabricación).
      #Es importante saber esto, pues debe evitarse el disparo de las protecciones magnéticas ante corrientes de falla pequeñas como las de unión de fase con la tierra. Esto solo para el caso de instalaciones TN en la que se espera que se use un diferencial para esta función.
      return @Im_minima
    end
     
    def fijo
      #Un automático que usa curvas, no tiene posibilidad de alteración de sus propiedades de disparo, siendo como es un dispositivo monolítico. Se califica como fijo. No confundir con otra característica de montaje fijo.
      #Entre los automáticos regulables, hay algunos que no pueden regular el disparo térmico y también son lllamados fijos. 
     true
    end

    def puts
     $logger.debug self.modelo
    end
 
  end


