module Electrico
  class Canalizacion < ElectricoBase
    self.table_name="canalizaciones"
    #attr_accessible :diametro_en_mm, :diametro_en_pulgada, :es_embutida, :es_rigida, :es_sobrepuesta, :nombre, :diametros_interior, :seccion_transversal, :espesor
    
    has_many :materiales, as: :materializable
      
    after_save :x
  accepts_nested_attributes_for :materiales, :allow_destroy => true



    private

    def x
      self.diametro_en_mm = self.diametro_en_pulgada.to_f / 2.25 unless self.diametro_en_pulgada.blank? || self.diametro_en_pulgada.nil?

      self.diametro_interior = self.diametro_en_mm.to_f - 2 * self.espesor unless self.espesor.blank? || self.espesor.nil?

      self.seccion_transversal = 3.1416 * (self.diametro_interior.to_f / 2 )* (self.diametro_interior.to_f / 2 ) unless self.diametro_interior.nil? || self.diametro_interior.blank?
    end
  end
end
