class Electrico::Checklist < Curso::Prueba
  #attr_accessible :modulo_id, :objetivo_id, :tema_id, :titulo, :semana, :preguntas_attributes, :objetivos_attributes, :duracion
  scope :respondido, ->{ where('params != nil')}
  #scope :with_tipo_auditoria_id, lambda{ |params| where( :tipo_auditoria_id => params[0] )}
  belongs_to :auditoria, :class_name => "Gestion::Auditoria"#, :inverse_of => :auditoria
  validates :auditoria, :presence  =>  true
  delegate :tipo_auditoria, to: :auditoria
# belongs_to :tema
# belongs_to :modulo

# has_many :objetivos
  
# validates :modulo_id, presence:true

# has_many :examenes, dependent: :destroy
  has_many :levantamientos, dependent: :destroy, :class_name => Electrico::Levantamiento


# has_many :participantes, :through => :examenes
# has_many :users, :through => :participantes
  has_many :partes
  #has_many :preguntas, :through => :partes
  has_many :preguntas, dependent: :destroy, :class_name => Curso::Pregunta
  has_many :alternativas, :through => :preguntas, :class_name => Curso::Alternativa

 accepts_nested_attributes_for :objetivos, :reject_if => lambda{|u| u[:descripcion].blank?}, :allow_destroy => true
  
  
  accepts_nested_attributes_for :preguntas, :reject_if => lambda{ |u| u[:enunciado].blank?}, :allow_destroy => true

  accepts_nested_attributes_for :alternativas, :reject_if => lambda{ |u| u[:enunciado].blank?}, :allow_destroy => true

  
end
