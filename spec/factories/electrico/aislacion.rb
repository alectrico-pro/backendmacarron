FactoryBot.define do

  factory :aislacion , class: Electrico::Aislacion do
    nombre {'THHN'}
    alma { 'Cu' }
    K    { 70 }
    tmaxima { 150 }
    es_conductor_activo_o_proteccion_multiconductor { true }
    after(:create) do |aislacion, evaluator|
     # $logger.info "Aislacion Factory creado #{aislacion.nombre}"
    end
  end

end
