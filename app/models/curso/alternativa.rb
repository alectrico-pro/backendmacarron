class Curso::Alternativa < ElectricoBase
  #attr_accessible :correcta, :enunciado, :pregunta_id, :pregunta_id
  #validates :pregunta_id, presence:true
  validates :enunciado, presence:true
#  validates :pregunta, presence: true #Genera error de validacion durante create 

  belongs_to :pregunta

  has_many :respuestas, dependent: :destroy

  scope :correctas, -> {where(correcta: true)}
end
