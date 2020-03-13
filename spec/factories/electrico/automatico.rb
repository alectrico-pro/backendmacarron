FactoryBot.define do 
  factory :automatico, :class => Electrico::Automatico do 
    id { 544 }  
    after(:create) do |automatico, evaluator|  
     # $logger.info "Automatico Factory Creado #{automatico.corriente_nominal}#{automatico.curva}-#{automatico.es_monofasico ? '1F' : ''}-pdc #{automatico.poder_corte}"
    end 
    factory :automatico_177 do 
      id           { 177 } 
      poder_corte  { 6 } 
      corriente_nominal {1} 
      curva     { 'B' }
      es_monofasico  { true } 
      es_bifasico { } 
      es_trifasico { } 
      es_mcb { true}
      es_diferencial { }
      tension { }
    end 
  end
end
