FactoryBot.define do

  factory :circuito, :class => Electrico::Circuito do
    largo { 10 }
    max_spur { 10 }
    grupo { 1  }
#    association :tipo_circuito, factory: :tipo_circuito_enchufes, strategy: :build
 #   association :canalizacion, factory: :canalizacion_pvc_conduit_16mm_pulg
  #  association :forro, factory: :forro_THHN
   # presupuesto
    transient do
      cargas_count { 5 }
    end

    factory :circuito_de_cocina,:class => Electrico::Circuito  do
      nombre { "Enchufes Cocina" }
      #association :canalizacion, factory: :canalizacion_pvc_conduit_16mm_pulg

      after(:create) do |circuito_con_cargas, evaluator|
#	$logger.info "Circuito Enchufes Cocina Factory Creado"
	create_list(:carga_de_microondas, evaluator.cargas_count, circuito: circuito_con_cargas)
	#circuito_con_cargas.presupuesto.ensure_instalacion
      end
    end

    factory :circuito_de_televisores, :class => Electrico::Circuito do
      nombre { "Enchufes Normales" }
      #association :canalizacion, factory: :canalizacion_pvc_conduit_16mm_pulg
      after(:create) do |circuito_con_cargas, evaluator|
#	$logger.info "Circuito de Televisores Factory Creado"
	create_list(:carga_de_televisores, evaluator.cargas_count, circuito: circuito_con_cargas)
	#ircuito_con_cargas.presupuesto.ensure_instalacion
      end
    end

    factory :circuito_de_refrigeradores, :class => Electrico::Circuito do
      nombre { "Refrigeradores" }
      after(:create) do |circuito_con_cargas, evaluator |
#	$logger.info "Circuito de Refrigeradores Factory Creado"
	create_list(:carga_de_refrigeradores, evaluator.cargas_count, circuito: circuito_con_cargas)
	#circuito_con_cargas.presupuesto.ensure_instalacion
      end
    end

  end
end
