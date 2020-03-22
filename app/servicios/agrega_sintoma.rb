class AgregaSintoma < AgregaCarga

  #Esta calse redefine get_equipo_con_image_url para agregar síntomas en lugar de cargas
  def get_equipo_con_image_url un_id
    linea.info "Encontrando equipo"
    linea.info "id es #{un_id}"
    ID_SINTOMAS.select{|id| id == un_id.to_i}.each_with_index do |id, index |
      equipo = Mock::TipoEquipo.new( id, NOMBRE_SINTOMAS[index], IMAGEN_SINTOMAS[index] )
      raise equipo.inspect
      return equipo
    end

  end

end

