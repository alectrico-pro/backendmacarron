module Electrico
  class Electrico::Automatico < ElectricoBase
    #attr_accessible :corriente_nominal, :curva, :es_bifasico, :es_mcb, :es_monofasico, :es_trifasico, :poder_corte, :es_diferencial,:materiales_attributes, :tiene_automatico, :tension

    has_many :circuitos
    has_many :materiales, as: :materializable
    scope :es_diferencial, -> {where(es_diferencial:true)}

    accepts_nested_attributes_for :materiales, :allow_destroy => true

    def In
     @In = self.corriente_nominal
    end
  end
end
