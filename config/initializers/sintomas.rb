COVID=ENV['COVID']
DESIGNER=ENV['DESIGNER']

if COVID

  ID_SINTOMAS    = [ 100, 101 , 102, 103, 200, 201, 300, 400, 500, 501, 502, 503]
 
  NOMBRE_SINTOMAS = %w(Secreciones_Nasales
               Dolores_de_Garganta 
               Pérdida_de_Olfato_y_de_Sabor
               Problemas_Digestivos
               Tos_Seca
               Tos_Seca
               Fiebre
               Falta_de_Aire
               Hipertensión_Arterial
               Diabetes
               Asma
               Cardiopatía   )

  IMAGEN_SINTOMAS = %w(secreciones_nasales_01.jpg
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
else

end
