#No está en uso

class Carga::Agrega

  include ::Linea

  attr_reader :circuito

  def initialize repositorio, puerto, params
    @params        = params
    @repositorio   = repositorio
    @puerto        = puerto
  end

  def get_equipo_con_image_url un_id
    id                      = [844 ,99, 1363, 1692, 124, 236, 211, 579, 140, 843, 252, 921, 7, 276, 101, 36, 138, 71, 76]
    grupo                   = %w[green green green golden golden golden golden golden golden coral coral coral coral coral coral coral coral coral red red]
    image_tareas_60_40_url  = %w[/img/alectrico_60_40.png /img/mantencion_electrica_60_40.png /img/atencion_corte_de_luz_60_40.png /img/proyecto_energia_solar_60_40.png /img/instalacion_luminaria_60_40.png /img/instalacion_enchufe_60_40.png /img/instalador_sec_60_40.png]
    image_60_40_url         = %w[/img/led_60_40.png /img/ampolleta_incandescente_60_40.png /img/juguera_60_40.png /img/microondas_60_40.png /img/hornillo_60_40.png /img/hervidor_60_40.png /img/olla_arrocera_60_40.png /img/cafetera_expresso_60_40.png /img/plancha_60_40.png /img/frigobar_60_40.png /img/refrigerador_60_40.png /img/refrigerador_dos_puertas_60_40.png /img/lavadora_de_ropa_60_40.png /img/secadora_de_ropa_60_40.png /img/lavaplatos_60_40.png /img/splitter_60_40.png /img/pc_60_40.png /img/encimera_60_40.png /img/encimera_induccion_60_40.png]
    image_tareas_url        = %w[img/mantencion_electrica.png /img/atencion_corte_de_luz.png /img/proyecto_energia_solar.png /img/instalacion_luminaria.png /img/instalacion_enchufe.png /img/instalador_sec.png]
    full_image_url          = %w[ /img/led.png /img/ampolleta_incandescente.png /img/juguera.png /img/microondas.png /img/hornillo.png /img/hervidor.png /img/olla_arrocera.png /img/cafetera_expresso.png /img/plancha.png /img/frigobar.png /img/refrigerador.png /img/refrigerador_dos_puertas.png /img/lavadora_de_ropa.png /img/secadora_de_ropa.png /img/lavaplatos.png /img/splitter.png /img/pc.png /img/encimera.png /img/encimera_induccion.png]

    id.select{|id| id == un_id.to_i}.each_with_index do |id, index | 
      equipo = Mock::TipoEquipo.new( id, full_image_url[index], full_image_url[index] )
      return equipo
    end
  end

  def find_tipo_circuito_by_letras letras
    tipo_circuitos = { "1" => ['D', 'Dormitorio',            16, true],
                       "2" => ['I', 'Iluminación',           10, false],
                       "3" => ['N', 'Enchufes Normales',     16, true],
                       "4" => ['F', 'Enchufes Libres',       16, true],
                       "5" => ['C', 'Calefacción',           20, true],
                       "6" => ['A', 'Aire Acondicionado',    20, true],
                       "7" => ['X', 'Alimentador',           16, true],
                       "8" => ['R', 'Refrigerador' ,         10, true],
                       "9" => ['L', 'Exclusivo Loggia',      16, true],
                       "10"=> ['S', 'Sala',                  16, true],
                       "11"=> ['H', 'Horno',                 16, true],
                       "12"=> ['M', 'Mesón',                 20, true],
                       "13"=> ['G', 'Legrand',               16, true],
                       "14"=> ['Z', 'Exclusivo Lavavajilla', 16, true],
                       "15"=> ['E', 'Exclusivo Encimera',    32, true]}


    linea.error "No se ingresó el índice de letras para encontrar el tipo de circuito" unless letras
    return false unless letras
    registro = tipo_circuitos.select{|id, registro| registro[1][0].include? letras.to_s}
    tipo_circuito = {
    :id                   => registro.first[0],  
    :letras               => registro.first[1][0],
    :nombre               => registro.first[1][1],
    :capacidad            => registro.first[1][2],
    :requiere_diferencial => registro.first[1][3]
   }
    #ipo_circuito = @repositorio.get_tree["circuitos"].select{|id, nombre| id.include? letras.to_s}.first
  end

  def find_tipo_equipo_by_id id 
    linea.info "Estoy en find_tipo_equipo_by_id id es #{id}"
    linea.error "No id de carga en los parámetros" unless id
    return false unless id

    ["green","blue","red","gold","coral"].each{ |color|
      orden  = @repositorio.get_tree[color]["ids"].select{|orden, id| id.include? id.to_s}.first
      if orden
        linea.info "orden del tipo de equipo es #{orden}"
        nombre = @repositorio.get_tree[color]["nombres"].select{|orden,id| orden.include? orden.first}.first
          if nombre 
            linea.info "Tipo de equipo se llama #{nombre}"
            #img = @repositorio.get_tree[color]["imgs"].select{|orden,id| orden.include? orden.first}.first
            #repositorio.get_nombre_de_tipo_equipo
       
            tipo_equipo = TipoEquipo.new(nombre.last)
            img = @repositorio.get_img_de_tipo_equipos[tipo_equipo.id.to_s]
            tipo_equipo.id = id.to_i
            tipo_equipo.img = img
            return tipo_equipo
          else
            linea.error "No se econtró nombre para el tipo de equipo requerido"
          end
      else
        linea.error "No se encontró el tipo de equipo para el id #{id}"
      end
    }
  end

  def agrega_carga 

    tipo_circuito_hash = find_tipo_circuito_by_letras @params[:circuito]
    linea.info "Tipo de Circuito Encontrado #{@params[:circuito]}" if tipo_circuito_hash

   # equipo_existe   = find_tipo_equipo_by_id @params[:carga_id] 
    #linea.info "Tipo de Equipo Encontrado" if equipo_existe

    tipo_equipo =  get_equipo_con_image_url @params[:carga_id] 
   
    if tipo_equipo and tipo_circuito_hash

      tipo_circuito = Mock::TipoCircuito.new( tipo_circuito_hash['id'], tipo_circuito_hash['letras'], tipo_circuito_hash[:nombre], tipo_circuito_hash['capacidad'], tipo_circuito_hash['requiere_diferencial'] )
      largo = 10
      max_spur = 10
      grupo = 1

      @circuito = Mock::Circuito.new( largo, max_spur, grupo, tipo_circuito)
=begin
      tipo_equipo = Electrico::TipoEquipo.create(
                           :id                        => t_equipo.id,\
                           :nombre                    => t_equipo.nombre,\
                           :img                       => t_equipo.img,\
                           :tension                   => 220,\
                           :fp                        => 0.85,\
                           :p                         => 2000,\
                           :eficiencia                => 100,\
                           :es_monofasico             => true,\
                           :modelo                    => "Microondas Genérico",\
                           :capacitancia_necesaria    => 82,\
                           :i                         => 10.7,\
                           :curva                     => 'C')          
=end
      carga   = Mock::Carga.new( @params[:carga_id], tipo_equipo, @params[:carga_qty], @circuito )

      @circuito.cargas << carga
      linea.info "Se agregó carga al circuito"
      resultado = true

    end

    redireccionar resultado

  end

  def redireccionar resultado
    linea.info "Redireccionando #{resultado}"
    resultado ? @puerto.carga_exitosamente_agregada(self) : @puerto.carga_fallidamente_agregada(self)
  end

end
