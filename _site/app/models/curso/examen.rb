class Curso::Examen < ElectricoBase
  #attr_accessible :aprobado, :buenas, :demora, :fecha, :malas, :nota, :omitidas, :participante_id, :prueba_id, :regular, :total


 logger = Logger.new(STDOUT)
 logger.level = Logger::INFO

  belongs_to :prueba
#  belongs_to :checklist, :class_name => Electrico::Checklist
  belongs_to :participante
  validates :participante, :presence => true, if: :examen?

  def aprobado?
    if self.aprobado
      return 1
    else
      return 0
    end
  end  

  def examen?
    self.class == Curso::Examen
  end

  validates :participante, presence:true, if: :examen?
#  validates :participante, presence:true
  validates :prueba, presence:true, if: :examen?
  #validates :prueba, presence:true

  def examen?
    #Permite validar solamente a los examenes y no a los levantamientos
    #raise self.class.name.inspect
    self.class == Curso::Examen
  end

  #validates_uniqueness_of :participante_id, :scope => [:prueba_id]

  after_initialize :init

  has_many :respuestas, dependent: :destroy
  has_many :respuestas #hacer codigo para borar respuestas suelts en delayed_job
  has_many :alternativas,:through => :respuestas
 
  def init
    self.nunca_abierto = true
  end

  #castigo por responder mal a una alternativa (0.25 es el 25% del puntaje de esas alternativa
  def castigo
   return 0.25
  end

  #porcentaje de puntos con respecto al puntaje total que es necesario obtener para que el examen sea considerada aprobado Normalmente 60 corresponde al 60%
  def marca_de_aprobado
    return 60
  end



#======================== comienzo state machine ===============

    state_machine :estado, :initial => :creado do


=begin
  class ::InvalidTransition < StandardError
  end

  rescue_from InvalidTransition, :with => :invalid_transition

  def invalid_transition(exception)
    flash[:notice] = "Error al guardar el examen!"
    Eent.new_event "Exception: #{exception.message}", current_user, request.remote_ip
    redirect_to "/clases"
  end
=end



    #before_transition :creado => :publicado, :do => :graba

    around_transition do |examen, transition, block|
#      logger.info "Estoy en around transition de examenes"
#      logger.info "============"
#      logger.info examen.prueba.titulo
 #     logger.info transition.inspect
      #start = Time.now.to_f
      block.call
      #@tiempo_transcurrido ||= 0.00
      #@tiempo_transcurrido += Time.now.to_f - start
    end

    event :publica do
      transition :creado => :publicado
    end
    
    event :toma do
      transition :publicado => :tomado
    end

    event :responde do
      transition :tomado => :respondido
    end

    event :evalua do
      transition :respondido => :evaluado
    end

    state :creado do
      def creado?
	true
      end
    end
    state :publicado do
      def publicado?
	true
      end
    end
    
    state :tomado do
      def tomado?
	true
      end
    end

    state :respondido do
      def respondido?
	true
      end
    end

    state :evaluado do
      def evaluado?
	true
      end
    end

  end
  #
  #
  #
  #
#======================== fin estates machine ==================

end
