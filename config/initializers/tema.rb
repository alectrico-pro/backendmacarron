TEMA=ENV['TEMA']

if TEMA == 'COVID'

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

  IMAGEN_SINTOMAS = %w(/sintomas/secreciones_nasales_01.jpg
               /sintomas/dolores_de_garganta_01.jpg
               /sintomas/sin_olfato_ni_sabor.jpeg
               /sintomas/problemas_digestivos.jpg
               /sintomas/tos_03.jpg
               /sintomas/tos_02.png
               /sintomas/fiebre_04.jpg
               /sintomas/taquipnea_03.jpg
               /sintomas/hipertension_01.jpeg
               /sintomas/diabetes_01.jpg
               /sintomas/asma_01.jpg
               /sintomas/cardiopatia_01.jpg  )

elsif TEMA == 'DESIGNER'

  ID_SINTOMAS      = [ 844, 
                       99,
                       1363,
                       1692,
                       124,
                       236,
                       211,
                       579,
                       140,
                       843,
                       252,
                       921,
                       7,
                       276,
                       101,
                       36,
                       138,
                       71,
                       76]

  NOMBRE_SINTOMAS = %w(Ampolleta Led.
                       Ampolleta Incandescente.
                       Licuadora.
                       Microondas.
                       Hornillo.
                       Hervidor.
                       Olla Arrocera.
                       Cafetera Expresso.
                       Plancha.
                       Frigobar.
                       Refrigerador de dos puertas.
                       Lavadora de ropas.
                       Secadora de ropas.
                       Lavalozas.
                       Splitter.
                       Computador.
                       Cocina Encimera Vitrocerámica.
                       Cocina Encimera Inducción.
                    )

IMAGEN_SINTOMAS =    %w(led.png
                        ampolleta_incandescente.png
                        juguera.png
                        microondas.png
                        hornillo.png
                        hervidor.png
                        olla_arrocera.png
                        cafetera_expresso.png
                        plancha.png
                        frigobar.png
                        refrigerador.png
                        refrigerador_dos_puertas.png
                        lavadora_de_ropa.png
                        secadora_de_ropa.png
                        lavaplatos.png
                        splitter.png
                        pc.png
                        encimera.png
                        encimera_induccion.png
                     )

end
