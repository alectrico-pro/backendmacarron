class GetCargas

  include ::Linea

  def initialize( repositorio, puerto )
    linea.info "Initializing GEtCargas"
    @repositorio = repositorio
    @puerto      = puerto
  end

  def get circuito
    linea.info "getting cargas from circuito"
#    @puerto.get_cargas circuito.cargas
    circuito#.cargas
  end

end
