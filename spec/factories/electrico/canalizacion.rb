FactoryBot.define do
  factory :canalizacion, :class => Electrico::Canalizacion do
    after(:create) do |canalizacion, evaluator|
     # $logger.info "Canalización Factory Creado #{canalizacion.nombre}#{canalizacion.diametro_en_mm}"
    end
    factory :canalizacion_pvc_conduit_16mm_pulg, aliases: [:canalizacion_1], :class => Electrico::Canalizacion do
      nombre  { 'PVC Conduit' }
      diametro_en_mm {16}
      diametro_en_pulgada { }
      espesor     { }
      es_embutida  { true }
      es_sobrepuesta { false}
      es_rigida { true}
      diametro_interior { }
      seccion_transversal { }
    end
  end
end
