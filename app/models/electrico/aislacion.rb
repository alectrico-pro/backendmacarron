  class Electrico::Aislacion < DBase
    self.table_name = "aislaciones"
    #attr_accessible :K, :alma, :es_conductor_activo_o_proteccion_multiconductor, :es_conductor_proteccion_no_agrupado, :nombre, :tmaxima

    has_many :forros
    scope :conductor_activo, -> {where(es_conductor_activo_o_proteccion_multiconductor: true , es_conductor_proteccion_no_agrupado: false)}

  #se refiere a solicitaciones termicas admisibles en conductores pagina 223

  end
