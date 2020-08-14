class Gestion::Auditoria < GestionBase


  scope :with_tipo_auditoria_id, lambda{ |params| where( :tipo_auditoria_id => params[0] )}
  scope :my_limit, ->(numero) { limit(numero)}
  scope :tipo    , ->(numero) { where(:tipo_auditoria_id => numero)}
  after_update do
    evidencias.update_all(updated_at: Time.now)
  end


  #add_foreign_key "gestion_auditoria","gestion_registros"
  #add_foreign_key "gestion_auditoria","gestion_usuarios"

  before_create :create_remember_token


  belongs_to :tipo_auditoria
  belongs_to :registro#, inverse_of: :auditoria #puede haber registros sin auditoria
  belongs_to :usuario#, inverse_of: :auditoria #puede haber usuarios sin auditorias

  belongs_to :presupuesto, :class_name => "Electrico::Presupuesto"

  validates :tipo_auditoria, :presence => true
  validates :registro, :presence => true
  validates :usuario, :presence => true
  validates :presupuesto, :presence => true

  has_many :evidencias, dependent: :nullify, inverse_of: :auditoria #no puede haber evidencias sin auditoria¡?
  has_many :criterios, :through => :evidencias

  has_many  :checklists, :class_name => Electrico::Checklist
  #delegate :nombre, :activo, :email, to: :usuario, prefix: :perfil, allow_nil: true
  delegate :master_checklist,        to: :tipo_auditoria, allow_nil: true
  delegate :id,                      to: :usuario, prefix: :auditor, allow_nil: true #puede haber users sin perfil (usuario nill)



  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end





