module Electrico
  class Event < ElectricoBase
    #Esta clase y sus subclaaes están deprecadas a favor de Gestion::Evento


  belongs_to :presupuesto

  validates :fecha, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #validates :titulo, presence: true

  validates :presupuesto_id, presence: true


  scope :openevent, -> {where(openevent: true)}

  end


end
