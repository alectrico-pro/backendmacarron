class Instalacion::Agrega < Agrega

  attr_reader :circuito

  def initialize circuito, repositorio, puerto, params
    @params        = params
    @circuito      = circuito
    @repositorio   = repositorio
    @puerto        = puerto
  end

  def agrega_carga

    tipo_circuito_hash = find_tipo_circuito_by_letras @params[:circuito]
    linea.info "Tipo de Circuito Encontrado" if tipo_circuito_hash

   # equipo_existe   = find_tipo_equipo_by_id @params[:carga_id] 
    #linea.info "Tipo de Equipo Encontrado" if equipo_existe

    tipo_equipo =  get_equipo_con_image_url @params[:carga_id]

    if tipo_equipo and tipo_circuito_hash

      tipo_circuito = Mock::TipoCircuito.new( tipo_circuito_hash['id'], tipo_circuito_hash['letras'], tipo_circuito_hash[:nombre], tipo_circuito_hash['capacidad'], tipo_circuito_hash['requiere_diferencial'] )

      @circuito = Mock::Circuito.new( 10, 10, 1, tipo_circuito)

      carga   = Mock::Carga.new( 1, tipo_equipo, 1, @circuito )

      @circuito.cargas << carga
      linea.info "Se agregó carga a circuito"
      resultado = true

    end

    byebug
    redireccionar resultado

  end

end
