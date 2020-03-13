module Electrico
  class TipoCircuito < ElectricoBase
    #attr_accessible :nombre
    validates :letras ,:presence => true
    validates :letras, :uniqueness => {
      # object = objeto tipo_circuito que se está validando
      # data = { model: "TipoCircuito", attribute: "letras", value: <letras> }
      message: -> (object, data ) do
	d = Electrico::TipoCircuito.find_by(:letras => data[:value])
        "Atención tipo_circuito con id: #{d.id}, tiene el valor #{data[:value]} repetido!"
      end
    }
    has_many :circuitos
    scope :requiere_diferencial, -> {where(requiere_diferencial: true)}
  end
end
