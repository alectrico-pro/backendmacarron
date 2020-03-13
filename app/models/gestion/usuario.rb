#include GeneralHelper
require 'dragonfly'
#require 'pathlinks'

require 'state_machines'


class MiValidador < ActiveModel::Validator

=begin
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
=end
=begin
  crea problemas con la ruta de code_imag
  crea problemas con la ruta de code_imagee
  def to_param
    "#{self.id}-#{self.nombre.gsub(" ", "_")}"
  end
  def self.from_param(param)
     find_by_nombre!(param)
  end
=end
  def validate(record)
    if options[:fields].any?{|field| record.send(field) == "Evil" }
      record.errors[:base] << "This person is evil"
    end
    record.errors[:email]  << "Buou"
    record.errors[:Aviso] << "Este dispositivo ya está asociado a otra cuenta"

  end
end



class Gestion::Usuario < GestionBase

  extend ::Dragonfly::Model

=begin
  def to_param
    "#{id}_#{nombre.truncate(20).gsub(" ", "_")}_#{nombre_archivo.nil? ? "" : nombre_archivo.truncate(20).gsub(" ", "_").gsub(".", "_")}"
  end

  def self.from_param(param)
    find_by_nombre!(param)
  end
=end

  #validates_with MiValidador, fields: [:clientId]

  after_touch do |usuario|
    logger.info "Usuario tocado #{usuario.nombre}"
#    raise "#{usuario.nombre} tocado"
  end
  

  logger = Logger.new(STDOUT)
  logger.level = Logger::INFO
##  validate  :email_correcto

  #validate :fono_correcto


  validates :clientId, presence: true, uniqueness: {:scope => :email, case_sensitive: true,:message => "Este dispositivo ya está asociado a este email"} , on: :acceso_amp 

  validates :nombre, presence: true, length: {maximum: 50}
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  VALID_FONO_REGEX = /\A(56|)\d{9}\z/i
  validates :fono , presence: true, format: { with: VALID_FONO_REGEX}

# validates :fono,                  :presence => true
#  validates :fono,                  numericality: {only_integer: true, less_than: 999999999, greater_than: 200000000}
  has_many :presupuestos, :class_name => "Electrico::Presupuesto", dependent: :destroy
  has_many :tipo_auditorias, inverse_of: :autor
  #Los users son los usuarios de login, los que pueden borrarse por su propia cuenta, pero lo usuarios son los perfiles que pueden quedar y si quedan permiten econtrar la histori de quien participo en auditorias y subio evidencias. Si los perfiles se borrar, quedarán huérfanas las auditorias y las evidencias. Para que otro las retome.
  has_many :evidencias,     dependent: :destroy, inverse_of: :usuario #las evidencias deben tener un dueño usuario
  has_many :auditorias,     dependent: :destroy, inverse_of: :usuario#las auditorias deben tener un usuario
  has_many :eventos,        dependent: :destroy, inverse_of: :usuario
  has_many :eventos,        inverse_of: :ingeniero
  has_many :atenciones,     dependent: :destroy, inverse_of: :usuario

  #delegate :fono, to: :user, allow_nil: true

   belongs_to :user,  inverse_of: :usuario, :touch => true
    
    
     #puede haber usuarios que no tengan registro en user '¿
#  belongs_to :user

   validates :user, uniqueness: {:scope => :user_id, :message => "No se puede asociar un perfil a más de un usuario"} , if: :user_id 

  dragonfly_accessor :imagen

  scope :auditor,               -> {joins(:user).where('auditor = true')}

  def imagen_file=(input_data)
    self.tipo_contenido = input_data.content_type
    self.nombre_archivo = input_data.original_filename
    self.tempfile       = input_data.tempfile
    self.bits           = input_data.read
#    self.imagen         = self.bits.clone
  end

  def crea_user
    user = ::User.find_or_create_by(:email => self.email) do |u|

      u.name     = self.nombre
      u.email    = self.email
      u.fono     = self.fono
      u.password = self.fono
    end
    self.user_id = user.id
  end

  def prepare
    #elf.imagen = self.bits.clone
    #elf.save
    self.update_attributes(:imagen => self.bits.clone) if self.bits
  end



#========================= ESTADOS ==========
  state_machine :estado, :initial => :visitante do

    event :registra do
      transition :visitante => :registrado
    end

    around_transition do |perfil, transition, block|

#      logger.info "Estoy en around transition en usuario (perfil)"
 #     logger.info "============"
 #     logger.info perfil.nombre
  #    logger.info transition.inspect

      start = Time.now.to_f

      #cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      #user[:password_digest] = BCrypt::Password.create(user.password, cost: cost)
      #user[:email] = user.email
      #user[:fono]  = user.fono
      #user[:name]  = user.name
      #user[:estado]= user.estado

      block.call
      @tiempo_transcurrido ||= 0.00
      @tiempo_transcurrido += Time.now.to_f - start
      #ogger.info usuario.tiempo_transcurrido
    end


    event :enrola do
      transition :registrado => :enrolado
    end

    event :desenrola do
      transition :enrolado => :registrado
    end


    state :enrolado do
      def reclutable 
	true
      end
    end

    state :registrado do
      def reclutable
	false
      end
    end

    state :visitante do
      def reclutable
	false
      end
    end

    def initialize 
      super()
    end

  end

end
