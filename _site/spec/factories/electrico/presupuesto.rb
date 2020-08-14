FactoryBot.define do
  factory :presupuesto ,:class => Electrico::Presupuesto do    
#    id { Faker::Number.number(4) }
    usuario
    admin
    instalador
    descripcion { Faker::Movies::StarWars.character }
    direccion { Faker::Address.full_address }
    transient do
      crear_instalacion { false }
    end
    after(:create) do |presupuesto, evaluator|
      #$logger.info "Presupuesto #{presupuesto.id} factory creado"
      if evaluator.crear_instalacion == true
	#$logger.info "ensure_instalacion"
	presupuesto.ensure_instalacion
	presupuesto.save!
      end
    end
  end
end
