FactoryBot.define do

  factory :carga, :class => Electrico::Carga do
    association :tipo_equipo, factory: :tipo_equipo
    after(:create) do
     # $logger.info "Carga factory creado"
    end
  end

  factory :carga_de_microondas, :class => Electrico::Carga do
    association :tipo_equipo, factory: :tipo_equipo_microondas
    after(:create) do
     # $logger.info "Carga factory creado"
    end
  end

  factory :carga_de_televisores, :class => Electrico::Carga do
    association :tipo_equipo, factory: :tipo_equipo_televisor
    after(:create) do
     # $logger.info "Carga de Televisores Factory Creado"
    end
  end

  factory :carga_de_refrigeradores, :class => Electrico::Carga do
    association :tipo_equipo, factory: :tipo_equipo_refrigerador
    after(:create) do
     # $logger.info "Carga de Refrigeradores Factory Creado"
    end
  end

end
