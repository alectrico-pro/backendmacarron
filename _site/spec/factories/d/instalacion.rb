FactoryBot.define do
  factory :instalacion, :class => D::Instalacion do
    transient do
      configurar_instalacion { false }
    end
    after(:create) do |instalacion, evaluator| 
#      $logger.info "Instalacion factory creada"
      if evaluator.configurar_instalacion 
 #       $logger.info "Antes de llamar a instalación configurar en factory instalaición"
        instalacion.configurar(1,"")
      end
    end
  end
end
