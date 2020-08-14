FactoryBot.define do
  
  factory :electrico_forro, :class => Electrico::Forro do
    temperatura_servicio { 90 }
    aislacion
    after(:create) do |electrico_forro, evaluator|
     # $logger.info "Electrico_forro factory creado #{electrico_forro.letras}"
    end
  end


  factory :forro, :class => Electrico::Forro, aliases: [:forro_THHN] do
    temperatura_servicio { 90 }
    aislacion 
    letras { 'THHN' }
    chaqueta_exterior {'Nylon'}
    es_unipolar { true }
    ambiente_seco { true }
    ambiente_humedo { true}
    en_ducto {true}
    en_tuberia { true }
    en_bandeja { true }
    en_escalerilla { true }
    en_moldura { true }
    para_cable { true}
  end

end
