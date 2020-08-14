class Gestion::Criterio < GestionBase
  belongs_to :tipo_auditoria
  default_scope { order(numeral: :asc) }
  has_many :evidencias, dependent: :nullify, inverse_of: :criterio #las evidencias siempre deben tener un criterio
  belongs_to :auditoria, inverse_of: :criterio

  has_many :preguntas, :class_name => Curso::Pregunta
 # scope :con_una_evidencia, -> {where("gestion_evidencias_count > 0") }

  def self.con_una_evidencia
     where("gestion_evidencias_count > 0")  
  end

end
