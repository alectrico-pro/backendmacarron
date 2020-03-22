class AgregaSintoma < AgregaCarga

  #Esta calse redefine get_equipo_con_image_url para agregar síntomas en lugar de cargas
  def get_equipo_con_image_url un_id
     linea.info "Encontrando equipo"

     id   = [ 101, 102 , 103, 104, 201, 202, 300, 400, 501, 502, 503, 504]

     nombre = %w(Secreciones_Nasales
               Dolores_de_Garganta 
               Pérdida_de_Olfato_y_de_Sabor
               Problemas_Digestivos
               Tos 
               Tos 
               Fiebre
               Falta_de_Aire
               Hipertensión_Arterial
               Diabetes
               Asma
               Cardiopatía   )


    imagen = %w(secreciones_nasales_01.jpg
               dolores_de_garganta_01.jpg
               sin_olfato_ni_sabor.jpeg
               problemas_digestivos.jpg
               tos_03.jpg
               tos_02.png
               fiebre_04.jpg
               taquipnea_03.jpg
               hipertension_01.jpeg
               diabetes_01.jpg
               asma_01.jpg
               cardiopatia_01.jpg  )

    id.select{|id| id == un_id.to_i}.each_with_index do |id, index |
      equipo = Mock::TipoEquipo.new( id, nombre[index], imagen[index] )
      return equipo
    end

  end

end

