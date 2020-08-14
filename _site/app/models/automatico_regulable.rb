  #Define el comportamiento de los automaticos a los que se les puede regular el umbral de dispario termico y el umbral de disparo del magnetico,
# Nota, algunos automáticos, como el DRX se denominan fijos porque no pueden regular el térmico. Es igual a los modulares
  
  class AutomaticoRegulable < ProteccionAutomatica
    MARGEN = 0.9 

    def to_json(*a)
      data = {
               'calibre'       => @In,
               'modelo'        => @modelo,
               'ajuste_minimo' => @minima_regulacion_del_termico_per_design,
               'caja'          => @formato,
	       'voltaje'       => @tension,
               'ir_minima'     => @Ir_minima,
               'domiciliario'  => @domiciliario,
               'industrial'    => @industrial,
	       'medidas'       => @medidas,
	       'In'            => @In,
	       'proteccion_tierra' => @proteccion_tierra,
	       'montaje'       => @montaje,
	       'Ir'            => @Ir,
	       'Ir_maxima'     => @Ir_maxima,
	       'Ir_minima'     => self.Ir_minima,
               'regulacion'    => @regulacion,
	       'regulacion_media' => @regulacion_media,
	       'Im'            => @Im,
	       'Im_maxima'     => @Im_maxima,
	       'referencia'    => @referencia,
	       'Is'            => @Is,
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
      pdc            = PdC.json_create(o['pdc'])
      attrs          = JSON.parse(o['data'])
      
      n = AutomaticoRegulable.new(pdc, attrs['calibre'].to_i,attrs['modelo'],attrs['ajuste_minimo'].to_f,attrs['caja'],attrs['voltaje'].to_i)

      n.Ir_minima    = attrs['ir_minima']
      n.domiciliario = attrs['domiciliario']
      n.industrial   = attrs['industrial']
      n.medidas      = attrs['medidas']
      n.In           = attrs['In']
      n.proteccion_tierra = attrs['proteccion_tierra']
      n.montaje      = attrs['montaje']
      n.Ir           = attrs['Ir']
      n.Ir_maxima    = attrs['Ir_maxima']
      n.Ir_minima    = attrs['Ir_minima']
      n.regulacion   = attrs['regulacion']
      n.regulacion_media = attrs['regulacion_media']
      n.Im           = attrs['Im']
      n.Im_maxima    = attrs['Im_maxima']
      n.referencia   = attrs['referencia']
      n.precio       = attrs['precio']
      n.Is           = attrs['Is']
      n.set_polos (attrs['polos'])
      return n
      
    end

    def medidas=(a_medidas)
      @medidas = a_medidas
    end


    def get_Ir
      @Ir
    end

    def Ir=(a_Ir)
      @Ir = a_Ir.to_f
    end

    def proteccion_tierra=(a_proteccion_tierra)
      @proteccion_tierra = a_proteccion_tierra
    end

    def montaje=(a_montaje)
      @montaje = a_montaje
    end

    def regulacion_media=(a_regulacion_media)
      @regulacion_media = a_regulacion_media.to_f
    end

    def regulacion=(a_regulacion)
      @regulacion = a_regulacion.to_f
    end

    def Im_maxima=(a_Im_maxima)
      @Im_maxima = a_Im_maxima.to_f
    end

    def Ir_maxima=(a_Ir_maxima)
      @Ir_maxima = a_Ir_maxima.to_f
    end

    def Ir_minima=(a_Ir_minima)
      @Ir_minima = a_Ir_minima.to_f
    end

    def initialize(poder_de_corte, calibre, modelo,ajuste_minimo,caja,voltaje = 220)
      super(poder_de_corte, calibre, modelo,voltaje, caja)
      #Ahya automatícos compatibles con IEC 60947 que estan diseñados para operar en esa temperatura (40)
      #Cuando la temperatura de la envolvente varia , conviene desclasfiicar la corriente nominal estimada para evitar desconexiones intempestivas
      #No se está tomando en cuenta eso aqui
      @minima_regulacion_del_termico_per_design= ajuste_minimo
      
    end

    def curva
      #No usan curvas para expresar sus características de disparo, ya que se pueden regular
      return ''
    end

    def n_magnetico_fijo=(n)
      #Algunos no tienen capacidad de regulación del umbral magnético
      @n_magnetico_fijo=n
    end

    def In=(a_in)
      #Corriente nominal, se usa para identificar al componente. Pero para seleccionarlo debe usar la corriente de regulación. En los automáticos modulares se usa In porque es fija. Acá In es variable y adopta el nombre de Ir.
      @In=a_in
    end

    def Im=(im)
      #Es el valor mínimo de corriente en el circuito capaz de activar la apertura del disyuntor. Esta activación es considerada instantánea. En los disyuntores termomagnéticos de denomina corriente de umbral magnético en los electrónicos se denomina umbral fijo de activación instánea o Ics
      @Im=im
    end

    def In
      #Corriente nominal de la protección.
      return @In
    end

    def minima_regulacion_del_termico_per_design=(regulacion_minima)
      #Porcentaje mínimo de In que se puede regular como Ir. Es una limitación de fabricación.
     @minima_regulacion_del_termico_per_design=regulacion_minima
    end

    def minima_regulacion_del_termico_per_design
      return @minima_regulacion_del_termico_per_design
    end

    def medidas=(medida) 
      #Define si la protección ofrece posibilidad de medir algo
      @medidas=medida
    end

    def proteccion_tierra=(tierra)
      #Define si la protección puede proteger de una falla a tierra
      @proteccion_tierra = tierra
    end

    def principio=(a_principio)
      #Pricipio de funcionamiento, básicamente electrónicos o termomagnéticos
      @principio = a_principio
    end

    def principio
      return @principio
    end

    def montaje=(a_montaje)
      @montaje=a_montaje
    end

    def limitacion
      #limitación de la corriente de falla, es una optimización que ofrecen algunas protecciones para impedir que la corriente de falla sea muy grande. Son capaces de disipar la energía en una fracción del período de oscilación de la corriente. Es una especificación energética pues considera la corriente y el tiempo de existencia.
      #Cuando interviene una protección con algún tipo de clase de limitación se espera una mejoría en la duración de los conductores ya que las fallas ocurrirán a menor valor pico de corriene. Por lo mismo, es de esperar menor riegos de incendio.
      #También es útil para disminuir costos ya que se puede aprovechar para usar protecciones de menor poder de corte 
     if self.In <= 40 and self.industrial.nil?
      return  @clase3
     end
    end

    def minima_regulacion_del_termico_per_design
      return @minima_regulacion_del_termico_per_design
    end

    def cumple_In?(is, iz)
      #Criterio principal de selección de una protección regulable. Se calcula Ir y se compara con Is e Iz
      @Is = is
      @Iz = iz
      return false if self.Ir.nil?
      #f self.Ir>= @Is and self.Ir <= @Iz*MARGEN
      #nd
      return true if (self.Ir >= @Is  and self.Ir <=  @Iz*MARGEN)
    end

    def cumple_Im?(icc_minima,regimen) #icc_minima esta en kA
      #El umbral magnético mínimo de disparo debe ser menor que la corriente de falla minima en el caso del regimen de neturo TN. Esto es porque las protecciones se ocupan de la falla a tierra, en vez de usarse un diferencial para ello. De esta forma las protecciones se dispararán ante la menor falla. Pero la corriente de falla en el regimen TN es bastante más alta que en TT porque el circuito de falla no incluye a la resistencia de tierra. Así es que el riesgo de incendio es más alto por esta razón. En el caso de TT, el diferencial está mejor preparado para abrir todo y las protecciones magnéticas quedan solo para el caso de cortocircuito fase nuetro o fase - fase
      return true if regimen == "TT"
      @Im_maxima = 1000*icc_minima.to_f/1.2
      if @Ir*10 <  @Im_maxima
	@Im=@Ir*10
	#$logger.info "Cumple Im"
	return true
      else
	@Im=nil
#	$logger.info "no cumple para Im: Im_maxima es #{@Im_maxima}A, La Ir es #{@Ir} y la corriente de disparo, Im es de #{@Im}"
	return false
      end
    end

    def Ir=(a_Ir)
      @Ir = a_Ir
    end

    def Ir
      #byebug
      #Ir es la corriente que resulta de aplicar la regulación
      raise self.regulacion.to_s
      unless self.regulacion?
        @Ir= self.regulacion*@In
        return @Ir
      else
	return nil
      end
    end

    def cumple_Ir?
      #En lugar de comparar con In, una protección regulada debe compararse contra Ir
      unless self.Ir.nil?
        if (self.Ir <= @Iz.to_f and @Is.to_f <= self.Ir)
          return true
       else
          return false
       end
      else
	return false
      end
    end

    def Ir_maxima
      #Es la corriente maxima Ir, debe corresponder con In pero no puede serlo porque no debe permitir más corriente que Iz, que es la corriente del conductor que tiene conectado. 
      if @Ir_maxima.nil?
	unless @In.nil?
	return @Iz 
	else
	  raise "No se ha podido determinar In del Automatico Regulado"
	end
      else
	return @Ir_maxima
      end
    end

    #Calcula la corriente de activación minima del térmico
    def Ir_minima
      if @Ir_minima.nil?
	unless @Is.nil?
          return @Is
	else
	  raise "No se ha podido determinar Is del Automatico Regulado"
	end
      else
	return @Ir_minima
      end
    end

    #Calcula la regulacion media que puede entregar la protección
    def regulacion_media
      if self.Ir_maxima >= self.Ir_minima
        @regulacion_media = (self.Ir_maxima.to_f+ self.Ir_minima.to_f)/(2*@In)
	return @regulacion_media
      else
	return nil
      end
    end

    #Calcula la regulacion adecuada a los requerimientos que plantea el circuito a considerar
    def regulacion
      if self.regulacion_media.nil?
	return nil
      end
      unless @Iz.nil?
	 if self.regulacion_media > self.minima_regulacion_del_termico_per_design
	   if self.regulacion_media * @In < @Iz
	     #Se prefiere la regulación en la mitad del dial, lo que dá flexilibidad para quitar o agregar conductores o cargas
             @regulacion=@regulacion_media
	   else 
	     #Si la regulación media es muy grande se calcula como una fracción entre la corriente máxima admisible del conductor asociado y la corriente nomimal de la protección.  
	     @regulacion = @Iz/@In
	   end
	   @regulacion= 1 if @regulacion > 1 #Se corrige en caso de superar el límite
	   return @regulacion
	else
	  if self.minima_regulacion_del_termico_per_design <= self.Ir_maxima #Se corrige en caso de superar el límite inferior
            @regulacion = self.minima_regulacion_del_termico_per_design
	    return @regulacion
	  else
	  end
	end
      end
    end

    #Calcula la corriente del térmico
    def Ir
      if self.regulacion
        @Ir=self.regulacion*self.In
        return @Ir
      end
    end

    #Calcula la corriente máxima de activacion del magnetico
    def Im_maxima
      unless @Ir.nil?
        @Im_maxima= @Ir*10
        return @Im_maxima
      else
	return nil
      end
    end

    #Calcula la corriente de activacion
    def Im
      if @n_magnetico_fijo.nil?
	if @Is.nil? or @Iz.nil?
	  #Este es un valor aproximado, dado que no se puede regular el automatico hasta que no se tenga el valor de Is e Iz.
	  @Im=@In*10
	else
          @Im=self.Ir*10
	end
        return @Im
      else
	@Im=@n_magnetico_fijo*@In
      end
    end

  end

