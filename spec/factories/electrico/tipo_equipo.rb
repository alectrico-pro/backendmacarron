FactoryBot.define do
  factory :tipo_equipo ,:class => Electrico::TipoEquipo do    
#    id { Faker::Number.number(4) }
    nombre { "Microondas" }
    tension { 220 }
    fp { 0.85 }
    p { 2000 }
    eficiencia { 100 }
    es_monofasico { true }
    modelo { "Microonda Genérico" }
    capacitancia_necesaria { 82 }
    i { 10.7 }
    curva { 'C' }
  end


  factory :tipo_equipo_refrigerador, :class => Electrico::TipoEquipo do
    nombre { "Refrigerador 200 W" }
    tension { 220 }
    fp { 0.85 }
    p { 2000 }
    eficiencia { 100 }
    es_monofasico { true }
    modelo { "Frigidaire" }
    capacitancia_necesaria { 82 }
    i { 10.7 }
    curva { 'C' }
  end

  factory :tipo_equipo_microondas,:class => Electrico::TipoEquipo do
#    id { Faker::Number.number(4) }
    nombre { "Microondas" }
    tension { 220 }
    fp { 0.85 }
    p { 2000 }
    eficiencia { 100 }
    es_monofasico { true }
    modelo { "Microonda Genérico" }
    capacitancia_necesaria { 82 }
    i { 10.7 }
    curva { 'C' }
  end

  factory :tipo_equipo_televisor, :class => Electrico::TipoEquipo do
    nombre { "Televisor de 32 Pulgadas" }
    tension { 220 }
    fp { 0.85 }
    p  { 2000 }
    eficiencia { 100 }
    es_monofasico { true }
    modelo { "Phillips" }
    capacitancia_necesaria { 82 }
    i { 10.7 }
    curva { "C" }
  end

end
