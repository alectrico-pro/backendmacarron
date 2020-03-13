module Electrico
  class Clonacion < ElectricoBase
    belongs_to :copia, class_name: "Electrico::Presupuesto"
    belongs_to :original, class_name: "Electrico::Presupuesto"

    validates :copia, presence: true
    validates :original, presence: true
  end
end


