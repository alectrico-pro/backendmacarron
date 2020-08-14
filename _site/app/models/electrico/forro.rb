  class Electrico::Forro < ElectricoBase
    self.table_name = "forros"
    #attr_accessible :aislacion_id, :ambiente_humedo, :ambiente_mojado, :ambiente_seco, :chaqueta_exterior, :directamente_en_tierra, :emite_gases_corrosivos, :emite_gases_toxicos, :en_acometida, :en_bandeja, :en_ducto, :en_escalerilla, :en_moldura, :en_tuberia, :es_multipolar, :es_unipolar, :fuera_del_alcance, :grupo_canalizacion, :id, :instalacciones_aereas, :instalacion_sobrepuesta_sin_ducto, :instalaciones_subterraneas, :libre_de_halogenos, :para_alambre, :para_cable, :resiste_aceites, :resiste_acidos, :resiste_gasolina, :resiste_grasas, :sin_ducto, :sin_uv, :temperatura_servicio, :tendido_subterraneo, :uso_exterior, :uso_interior,:letras, :no_emite_gases_toxicos_ni_corrosivos, :forro_id

    self.primary_key = "id"
    belongs_to :forrizable, polymorphic: true, :optional => true
    #pagina 212 de la guia de potencia aislamientos de conductroes
    belongs_to :aislacion
    validates :aislacion, :presence => true
  end
