class AgregaSintoma < AgregaCarga

  #Esta calse redefine get_equipo_con_image_url para agregar síntomas en lugar de cargas
  def get_equipo_con_image_url un_id
    linea.info "Encontrando equipo"
    id     = ID_SINTOMAS
    nombre = NOMBRE_SINTOMAS
    imagen = IMAGEN_SINTOMAS

    index = ID_SINTOMAS.find_index(un_id.to_i)
    if index > 0
      equipo = Mock::TipoEquipo.new( un_id, NOMBRE_SINTOMAS[index], IMAGEN_SINTOMAS[index] )
      
      return equipo
    end

  end

end

