class Curso::Prueba < ElectricoBase
  #attr_accessible :modulo_id, :objetivo_id, :tema_id, :titulo, :semana, :preguntas_attributes, :objetivos_attributes, :duracion

  belongs_to :tema
  belongs_to :modulo

  has_many :objetivos
  
  validates :modulo, presence:true, if: :prueba?

  def prueba?
    self.class == Curso::Prueba
  end

  has_many :examenes, dependent: :destroy
  has_many :levantamientos, dependent: :destroy

  has_many :participantes, :through => :examenes
  has_many :users, :through => :participantes
  has_many :partes
  #has_many :preguntas, :through => :partes
  has_many :preguntas, dependent: :destroy
  has_many :alternativas, :through => :preguntas

  accepts_nested_attributes_for :objetivos, :reject_if => lambda{|u| u[:descripcion].blank?}, :allow_destroy => true
  
  
  accepts_nested_attributes_for :preguntas, :reject_if => lambda{ |u| u[:enunciado].blank?}, :allow_destroy => true
  
end
