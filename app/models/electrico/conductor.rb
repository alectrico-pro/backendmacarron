module Electrico
  class Conductor < ::DBase
    self.table_name="conductores"
    #attr_accessible :awg, :grupo, :izth, :ref, :seccion, :tamb,:materiales_attributes, :alma, :tservicio, :Iz

    has_many :materiales, as: :materializable, :class_name => "Electrico::Material"

    #belongs_to :forro
    has_many :circuitos, :class_name => "Electrico::Circuito"
    accepts_nested_attributes_for :materiales, :allow_destroy => true
    
    #default_scope { order('izth DESC')}
    scope :alambre, -> { where(awg: nil) }
    scope :cable ,  -> { where('awg is not ?', nil)  }



    validates :izth, :presence => true
    validates :seccion, :presence => true
    validates :tamb, :presence => true
    validates :grupo, :presence => true
    validates :tservicio, :presence => true
    validates :alma, :presence => true
    validates :espesor, :presence => true
    def get_iz
      self.Iz 
    end

    def self.select_by_izth (a_Izth,a_grupo)

      #seleccionar el primer conductor que cumpla izth y qu tenga materiales en la bodega
      #@conductor=Conductor.where("Izth > ?", a_Izth).select{|c| c.materiales.count >0}.first

      
       #seleccionar el primer conductor que cumpla izth 
      @conductor = Conductor.where("grupo = ?",a_grupo.to_s).order(:izth).where("Izth >= ?", a_Izth).first
      #@conductor = Conductor.where("grupo = ?",a_grupo.to_s).where("Izth >= ?", a_Izth).order(izth: :desc, tservicio: :asc).first


      #@conductor=Conductor.where("Izth > ?", a_Izth).first
      #raise @conductor.izth.to_s

    end
    
  end
end
