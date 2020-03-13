
#require 'active_model'
#require 'active_record'
require 'state_machines'
include ActionView::Helpers::NumberHelper
#include ::Pathlinks
   
include EventsHelper
module Electrico
  class Presupuesto < ElectricoBase


    def push
      #Envia invitación a todos los colaboradores para que opten a este presupuesto
      enviado = false
      Colaborador.activo.each do |c|
	c.notificaciones.each do |notif|
	  mensaje = {
	    title:          usuario.nombre,
	    body:           (comuna.nil? ? '' : comuna.upcase + " | ") + descripcion,
	    tag:            id, #Es importante, permite que haya notificaciones que no se mezclan, cuando lleguen al celular
	    tipo:           'presupuesto',
	    #sender_id:      self.current.id, 
	    receiver_id:    c.id,
	    presupuesto_id: id
	  } 
	  begin 
	    Webpush.payload_send(
	      :message      => JSON.generate(mensaje),
	      :endpoint     => notif.endpoint,
	      :p256dh       => notif.p256dh,
	      :auth         => notif.auth,
	      :ssl_timeout  => 5,
	      :open_timeout => 5,
	      :read_timeout => 5,
	      :vapid        => {
		   subject:      "mailto:sender@alectrico.cl",
		   public_key:   $vapid_public,
		   private_key:  $vapid_private,
		   expiration: 12 * 60 * 60
		}
	    )

            enviado = true
	  rescue Webpush::ExpiredSubscription => e
	    enviado = false
	    notif.destroy
	  rescue Webpush::InvalidSubscription => e
	    enviado = false
	    notif.destroy
	  rescue Webpush::Unauthorized => e
	    enviado = false
	    notif.destroy
	  rescue ArgumentError => e
	    enviado = false
	  rescue StandardError => e
	    enviado = false
	  end
        end
      end
      return enviado
    end

    #Return the current logged in user
    #To be consumed by Cable App
    def self.current
      begin
        id = cookies.encrypted[:_alectrico_site_session]['warden.user.user.key'][0][0]
      rescue
      end
#     if verified_user = Instalador.find_by(id: id) or verified_user = Colaborador.find_by(id: id) or verified_user == Cliente.find_by(id: id)
      if id and verified_user = User.find_by(id: id)
         verified_user
      else
      #   reject_unauthorized_connection
      end
    end

=begin
    def to_param
      "#{self.id}-#{self.descripcion.gsub(" ", "_")}"
    end

    def self.from_param(param)
       find_by_descripcion!(param)
    end
=end

     #Esta parte es para estate machines
     #no usar attr_accessor estado porque no lo guarda
     #include ActiveModel::Dirty
     #include ActiveModel::Validations

     #define_attribute_methods Esto es para state_machines


     after_touch do |p|

       logger.info "Kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk"
       logger.info "#{p.id} TOCADO PRESUPUESTO"
       logger.info "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk"
     end

      #alidate :trafo_invalido
      #connection if Rails.env.test?
#      logger = Logger.new(STDOUT)
 #     logger = logger
 #     logger.level = Logger::INFO
 
      #Declare that the trafo was invalid
      def trafo_invalido
	antes= errors.count
	errors.add(:skq, "Skq no puede ser nulo") unless skq
	errors.add(:str, "Str no puede ser nulo") unless str
	errors.add(:uo, "uo no puede ser nulo") unless uo
	errors.add(:un, "un no puede ser nulo") unless un
	errors.add(:ucc, "ucc no puede ser nulo") unless ucc
	return true if errors.count > antes 
      end

      validates :bloqueado, inclusion: { in: [ nil, false, true ], message: "Este registro está bloqueado"} if self.current and self.current.admin?
      validates :bloqueado, inclusion: { in: [ false ], message: "Este registro está bloqueado"} if self.current and not self.current.admin?

      validate  :no_mas_de_mil
      validate  :no_mas_de_cinco_efimeros

      validate  :asigna_responsables
#      validate  :crea_y_asigna_usuario, on: :acceso_publico
#      validate  :email_correcto,        on: :acceso_publico

#      validate :fono_correcto,          on: :acceso_publico
      
      validates :estado, presence: true
      validates :clientId, presence: true, uniqueness: {:scope => :usuario_id, case_sensitive: true,:message => "Este presupuesto ya está asociado"} , on: :problema

      validates :clientId, presence: true, uniqueness: {:scope => :usuario_id, case_sensitive: true,:message => "Este presupuesto ya está asociado"} , on: :designer
      validates :descripcion,           :presence => true, on: :acceso_publico
      validates :descripcion,           :presence => true, on: :problema
      validates :direccion,             :presence => true, on: :acceso_publico
      validates :direccion,             :presence => true, on: :direccion
     #validates :comuna,                :presence => true, on: :direccion
      VALID_COMUNA_REGEX = /(las condes|LAS CONDES|Las Condes|Condes|condes|providencia|PROVIDENCIA|Providencia|ñuñoa|Ñuñoa|ÑUÑOA)/i
     # validates :comuna, presence: true, format: { with: VALID_COMUNA_REGEX}, on: :direccion

      validates :name,                  :presence => true , on: :accesso_publico

      #etapas en ingreso de datos desde amp
      #problema
      validates :descripcion,           :presence => true, on: :problema

      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      validates :email, presence: true, format: { with: VALID_EMAIL_REGEX}, on: :acceso_publico

      VALID_FONO_REGEX = /\A(56|)\d{9}\z/i
      validates :fono , presence: true, format: { with: VALID_FONO_REGEX}, on: :acceso_publico
      validates :terminos_del_servicio, acceptance: true, on: :acceso_publico
      validates :consentimiento_informado, acceptance: true, on: :acceso_publico
      validates :declaracion_jurada   , acceptance: true
      validates :boleta_servicios     , acceptance: true

      def no_mas_de_cinco_efimeros
	if Electrico::Presupuesto.efimero.count > 1
	end
      end

      def no_mas_de_mil
	if Electrico::Presupuesto.all.count > 600 or Electrico::Carga.all.count > 6500 or Electrico::Circuito.all.count > 600
	end
      end

      before_save   :x
      before_create :defaulties
      before_create :ensure_largo
      before_create :create_remember_token
      #after_create  :ensure_instalacion "Se maneja ahora en uan transición de estado, antes de circuito
      has_many      :checklists, :through => :auditorias, :class_name => "::Gestion::Auditoria"

      #has_many      :cargas, :through =>  :circuitos, :class_name => Remote::Carga, as: :carga_remota #  if Electrico::Presupuesto.connection_config[:database] == Carga::Carga.connection_config[:database]
      #def cargas 
#	@cargas=[]
	#aise  Electrico::Presupuesto.connection_config[:database]
	#raise  Electrico::Carga.connection_config[:database]
#	circuitos.each{ |cto| cto.cargas.each{|c| @cargas << c }}# unless Electrico::Presupuesto.connection_config[:database] == Electrico::Carga.connection_config[:database]
#	return @cargas
#	return cto.cargas
#      end
      #has_many :cargas,       :through =>  :circuitos  if Electrico::Presupuesto.connection_config[:database] == Electrico::Carga.connection_config[:database]

      #Return the project circuits loads using sql
      def cargas_sql
	Electrico::Carga.find_by_sql("SELECT * FROM cargas INNER JOIN circuitos ON cargas.circuito_id = circuitos.id WHERE circuitos.presupuesto_id = #{self.id}")
#	Carga.find_by_sql("SELECT * FROM cargas INNER JOIN circuitos ON cargas.cargolizable_id = circuitos.id" ) #No funciona porque los sql son internos a cada base de datos. Aunque recuerdo algo de tablas externas cuando estudie bases de datos.
	#argas.find_by_sql("SELECT cargas.* FROM cargas INNER JOIN electrico.circuitos ON cargas.cargolizable_id = circuitos.id WHERE circuitos.presupuesto_id = #{self.id}  AND cargas.cargolizable_type = Electrico::Circuito")
      end

      alias_method :cargas, :cargas_sql if Rails.env.test?
      has_many :cargas,      :through => :circuitos unless Rails.env.test?

      has_many :fotos,        as: :fotolizable
      has_many :costos,       as: :costolizable , :class_name => "Electrico::Costo"
      #            dependent: :delete_all
      has_many :materiales,   as: :materializable#          dependent: :delete_all
      has_many :recintos,     as: :recintable#              dependent: :delete_all
#     has_many :circuitos,  :after_remove => :verifica_eliminacion, :dependent => :destroy,    dependent: :destroy, :class_name => "Electrico::Circuito"
      has_many :circuitos, :after_add    => :recalcula_circuitos, :after_remove => :verifica_eliminacion, :dependent => :destroy,  :class_name => "Electrico::Circuito"
      has_many :events,                                     dependent: :destroy
      has_many :openevents,                                 dependent: :destroy
      has_many :llamadas,                                   dependent: :destroy
      #has_many :costos_presupuestos#                        dependent: :delete_all
      has_many :clientes, dependent: :nullify
      has_many :attachments, dependent: :destroy
      has_many :levantamientos, dependent: :destroy, :class_name => "Electrico::Levantamiento"
      has_many :auditorias, dependent: :destroy, :class_name => "Gestion::Auditoria"
      has_many :tipo_auditorias, :through => :auditorias, :class_name => "Gestion::TipoAuditoria"
      has_many :criterios, :through => :auditorias, :class_name => "Gestion::Criterio"
      belongs_to :orden, :class_name => "Comercio::Orden", :foreign_key => :comercio_orden_id
      belongs_to :usuario, :class_name => "Gestion::Usuario", :touch => true


      has_many :reverse_clonaciones, foreign_key: "copia_id", class_name: "::Electrico::Clonacion"
      has_many :originales, through: :reverse_clonaciones, source: :original
      has_many :clonaciones, foreign_key: "original_id"
      has_many :copias, through: :clonaciones, source: :copia



      validates  :usuario,:presence => true, on: :problema
      validates_associated :usuario, on: :acceso_publico
      belongs_to :admin, :class_name => "Admin"
      validates  :admin, :presence => true

      belongs_to :instalador, :class_name => "Instalador"#, :foreign_key => :user_id
      validates  :instalador , :presence => true

      belongs_to :colaborador, :class_name => "Colaborador", :foreign_key => 'colaborador_id'
      belongs_to :backup     , :class_name => "::Colaborador"

      #belongs_to :propietario, :class_name => "Propietario"
      #validates :propietario,  :presence => true,
      #                         on: :certificando	
      VALID_RUT_REGEX = /\A(\d{1}|\d{2})\.\d{3}\.\d{3}\-(k|\d{1})\z/i

      validates :rut, format: {with: VALID_RUT_REGEX},:presence => true, 
	                       on: :certificando

      VALID_ROL_REGEX = /\A(\d{1}|\d{2}|\d{3}|\d{4}|\d{5})\-(\d{1}|\d{2}|\d{3}|\d{4}|\d{5})\z/i

      validates :rol, format: {with: VALID_ROL_REGEX}, :presence => true,
	                        on: :certificando

      belongs_to :te1_foto, :class_name => "Electrico::Foto"

      #Imposse a hard limit to the max number of circuits
      def no_puede_tener_mas_de_1_circuito_en_modo_facebook
        if circuitos.count > 1
          errors[:base] << "Un visitante no puede agregar más de un circuito"
          raise circuitos.count.to_s
        end
      end
      #validate :no_puede_tener_mas_de_1_circuito_en_modo_facebook
      #has_and_belongs_to_many :materiales, :join_table => "materiales_presupuestos"
      #has_many :materiales, as: :materializable, :through => :circuitos
      #has_many :costos, as: :costolizable, :through => :circuitos
      accepts_nested_attributes_for :fotos, :allow_destroy => true
      accepts_nested_attributes_for :attachments, :allow_destroy => true
      accepts_nested_attributes_for :clientes, :reject_if => lambda{|u| u[:name].blank?}, :allow_destroy => false
      accepts_nested_attributes_for :costos, :allow_destroy => true
      accepts_nested_attributes_for :recintos, :allow_destroy => true
      accepts_nested_attributes_for :llamadas,  :allow_destroy => true
      accepts_nested_attributes_for :materiales, :allow_destroy => true
      accepts_nested_attributes_for :circuitos, :allow_destroy => true
     
      default_scope                  -> {order('updated_at DESC')} 
      scope :efimero,                 -> {where(efimero: true)}
      scope :not_efimero,             -> {where(efimero: false)}
      scope :con_foto,                -> {where('foto_id > ?', 0) }
      scope :vigente,                 -> {where(vigente: true)}
      scope :porvisitar,              -> {where(visitar: true)}
      scope :porllamar,               -> {where(porllamar: true)}
      scope :mellamaran,              -> {where(mellamaran: true)}
      scope :porpresupuestar,         -> {where(presupuestar: true)}
      scope :cerrado,                 -> {where(vigente: false)}
      scope :no_rotten,               -> {where(rotten: nil) }
      scope :realizado,               -> {where(realizado: true)}
      scope :no_realizado,            -> {where.not(realizado: true)}
      scope :sin_colaborador,         -> {where(colaborador_id: nil)}
      scope :con_colaborador,         -> {where.not(colaborador_id: nil)}
      scope :rotten,                  -> {where(rotten: true) }
      scope :trabajando,              -> {where(trabajando: true)}
      scope :pagado,                  -> {where(pagado: true)}
      scope :con_backup,              -> {where(con_backup: true)}
      scope :no_pagado,               -> {where.not(pagado: true)}
      scope :full_test_enviado,       -> {where(full_test_enviado: true)}
      scope :full_test_no_enviado,    -> {where(full_test_enviado: nil, rotten: nil)}
      scope :ano_nuevo_enviado,       -> {where(ano_nuevo_enviado: true)}
      scope :ano_nuevo_no_enviado,    -> {where(ano_nuevo_enviado: nil, rotten: nil)}
      scope :manual_enviado,          -> {where(manual_enviado: true)}
      scope :manual_no_enviado,       -> {where(manual_enviado: nil, rotten: nil)}
      scope :no_bloqueado,            -> {where(bloqueado: nil)}
      scope :desbloqueado,            -> {where(bloqueado: false)}

      serialize :instalacion#, D::Instalacion

      #after_create :avisar_por_email, unless: :es_copia? #solo cuando es el original

      def es_copia?
        self.originales.any?
      end

      def get_subtotal_orden
        orden.subtotal
      end

      attr_reader :modo_texto, :presentacion

      #Return the Colaborator Presentation to a new Client
      #To be used by Whatsapp
      def presentacion
        "Hola #{self.usuario.nombre}, soy #{self.colaborador.usuario.nombre}, Colaborador Independiente de la aplicación https://alectrico.cl. Nuestras visitas, chequeo y presupuestos se organizan para que sucedan en el horario diurno: comprendido entre las 8:00 y las 18:00 horas y tienen un costo de $25.000. También se atiende emergencias en horario extraordinario por un precio mayor. Si le parece bien, envíe su dirección e iré a resolver su problema en el horario que Ud. defina. Gracias!".gsub!(' ','%20') if self.usuario and self.colaborador and self.colaborador.usuario
      end

      #Return the visits details to by show to the potencial client on WhatsApp
      def visita_texto
        if self.colaborador and self.colaborador.usuario
	  res = "\n" + "#{self.colaborador.usuario.nombre}, Colaborador Independiente de Aléctrico ha coordinado con Ud. una visita para "
	  res += "\n" + (self.fecha_visita.nil? ? " una fecha sin definir aún " : date_for_display(self.fecha_visita)) + ", en #{self.direccion} #{self.comuna ? "#{self.comuna.upcase}" : ''}."
	  res += " Por favor ¿Podría confirmar su participación?"
        end
      end

      #Return the Project's Budject to be seen on WhatsApp
      def modo_texto #Presupuesto en modo texto para enviar por Whatsapp
        if self.colaborador and self.colaborador.usuario
	  res = "Presupuesto de #{self.colaborador.usuario.nombre}, Colaborador Independiente de Aléctrico, https://alectrico.cl/providencia "
	  if self.materiales.any?
	    res += " ("
	    self.materiales.each do |m|
	      res += "\n" + m.descripcion.to_s + "\t" + number_to_currency( m.costo)
	     end
	     res += ")"
	  end
	  if self.costos.any?
	    res += "-("
	    self.costos.each do |c|
	      res += "\n" + c.descripcion.to_s + "\t" + number_to_currency(c.costo_unitario)
	    end
	    res += ")"
	  end
	  res += "-(" + "Total " + number_to_currency(self.precio) if self.precio
	  res += ")" 
        end
      end

      #Append a new visit's item to the Projects Bugdet 
      def agregar_visita
        tipo = Electrico::TipoCosto.find_by(:descripcion => "Visita")
        if tipo.present?
          self.costos.create(:tipo_costo => tipo)
          self.precio = tipo.monto
        end
      end

      #Send email to the crowd
      def avisar_por_email

        Electrico::DashboardMailer.reclutar_instalador(self).deliver
        ::User.colaboradores.activo.all.each do |c|
          Electrico::DashboardMailer.reclutar_colaborador(self,c).deliver if c.reclutable
        end
      end

       #Avisa a cada colaborador activo de que hay una solicitud disponible
      #y ofrece la oportunidad para tomarla
      def publicar

        ::User.colaboradores.activo.all.each do |suscriptor|

           ActionCable.server.broadcast( 
               "presupuestos:#{CANAL_PRESUPUESTOS_ID}",
               {
                   aviso: ::Electrico::PresupuestosController.render(
	         partial: 'electrico/presupuestos/aviso',
	          locals: {presupuesto: self, destinatario: suscriptor}),

            notificacion: ::Electrico::PresupuestosController.render(
                 partial: 'electrico/presupuestos/notificacion',
                  locals: {presupuesto: self, destinatario: suscriptor}),

                 resumen: ::Electrico::PresupuestosController.render(
                 partial: 'electrico/presupuestos/nuevo_resumen',
                  locals: {presupuesto: self, destinatario: suscriptor}),

               dashfront: ::Electrico::PresupuestosController.render(
                 partial: 'electrico/presupuestos/dashfront_colaborador',
                  locals: {presupuesto: self, user: suscriptor, locale: :colaborador})
	       }

           )
        end

      end


       #Muestra las solicitudes a sus nuevos dueños y las borra del resto
      def sync suscriptor
         if self.colaborador === suscriptor #El suscriptor tomó exitosamente el presupuesto

           @presupuestos = suscriptor.presupuestos

	   ActionCable.server.broadcast(
	       "presupuestos:#{CANAL_PRESUPUESTOS_ID}",
	       {
		 resumen: ::Electrico::PresupuestosController.render(
		 partial: 'electrico/presupuestos/nuevo_resumen',
		  locals: {presupuesto: self, destinatario: suscriptor}),

               dashfront: ::Electrico::PresupuestosController.render(
                 partial: 'electrico/presupuestos/dashfront',
                  locals: {presupuesto: self, user: suscriptor})
	       }
	   )
	 else #El suscriptor no tomó el presupuesto
	   ActionCable.server.broadcast(
	       "presupuestos:#{CANAL_PRESUPUESTOS_ID}",
	       {
		 resumen: ::Electrico::PresupuestosController.render(
		 partial: 'electrico/presupuestos/nada',
		  locals: {presupuesto: self, destinatario: suscriptor}),

               dashfront: ::Electrico::PresupuestosController.render(
                 partial: 'electrico/presupuestos/dashfront',
                  locals: {presupuesto: self, user: suscriptor})

	       }
	   )
	 end

         nones suscriptor
         dash_front_refresh instalador
      end

      #Limpía el presupuesto en los suscriptores que no son dueños. No lo limpia en el instalador
      def nones dueno

        ::User.colaboradores.activo.all.reject{ |n| n === dueno}.each do |suscriptor|
          ActionCable.server.broadcast(
              "presupuestos:#{CANAL_PRESUPUESTOS_ID}",
               {
                 resumen: ::Electrico::PresupuestosController.render(
                 partial: 'electrico/presupuestos/nada',
                  locals: {presupuesto: self, destinatario: suscriptor})
               }
           )
        end
      end

      #Actualiza _dash_front del instalador
      def dash_front_refresh user
          ActionCable.server.broadcast(
              "presupuestos:#{CANAL_PRESUPUESTOS_ID}",
               {
               dashfront: ::Electrico::PresupuestosController.render(
                 partial: 'electrico/presupuestos/dashfront',
                  locals: {presupuesto: self, user: user})
               }
           )
      end

      #Be sure than largo never be null, o better that have 5 metters at least
      def ensure_largo
        self.largo ||= 5
      end

      #Inform that this project has an installation automatically calculated
      def has_instalacion?
	return true if self.instalacion.present?
	return false
      end

      #Perform the necessary an long calculations to get a new diagrama unilineal
      def crea_instalacion_de_una

        #Sanitiza los datos de entradas. Agregando tipos de circuitos y canalizaiciones si es que no las tiene
        logger.info "Este presupuesto tiene #{self.circuitos.count} circuitos"
        forro = Electrico::Forro.find_by_letras('THHN')
        raise "No se encontró forro THHN" unless forro
        tipo_circuito_de_enchufes_libres = Electrico::TipoCircuito.find_by_letras('F')
        raise "No se encontró tipo de circuitos Libre (F)" unless tipo_circuito_de_enchufes_libres
        canalizacion = Electrico::Canalizacion.find_by(:diametro_en_mm => 16, :nombre => 'PVC Conduit')
        raise "No se encontró canalización pvc_16mm" unless canalizacion

	#Configura la instalación, asignando el transformador
        instalacion = D::Instalacion.new.configurar(1, "Instalacion A Posteriori").tramo_fijo


	#Arma la instalación, agregando todos los circuitos
	circuitos_con_cargas = circuitos.select{|c| c.cargas.count > 0}
	circuitos_con_cargas.each do |c|
	  c.forro ||= forro
     #      c.presupuesto ||= self 
#	  c.tipo_circuito ||= tipo_circuito_de_enchufes_normales
	  c.canalizacion ||= canalizacion
 #         c.corriente_servicio = c.cargas.sum(&:get_i)
	  c.save!
	end
	#Se calculan todos las protecciones del circuito
        instalacion.create(self)

	return instalacion
      end

      #Perform Diagram Unilineal Calculations also known has installation
      def crea_instalacion_de_una_v1

	logger.info "Este presupuesto tiene #{self.circuitos.count} circuitos"
	forro = Electrico::Forro.find_by_letras('THHN')
	raise "No se encontró forro THHN" unless forro
	tipo_circuito_de_enchufes_libres = Electrico::TipoCircuito.find_by_letras('F')
	raise "No se encontró tipo de circuitos Libre (F)" unless tipo_circuito_de_enchufes_libres
        canalizacion = Electrico::Canalizacion.find_by(:diametro_en_mm => 16, :nombre => 'PVC Conduit')
        raise "No se encontró canalización pvc_16mm" unless canalizacion
	#Crea una instalacion luego que se hayan creado todos los circuitos.
        instalacion = D::Instalacion.new.configurar(1, "Instalacion A Posteriori").tramo_fijo
	set_instalacion(instalacion)
    
        circuitos_sin_cargas = circuitos.select{|c| c.cargas.count == 0}.each.count	
        circuitos_con_cargas = circuitos.select{|c| c.cargas.count > 0}
	circuitos_con_cargas.each do |c|
          c.forro ||= forro
   #       c.presupuesto ||= self 
	  c.tipo_circuito ||= tipo_circuito_de_enchufes_libres
          c.canalizacion ||= canalizacion
	  c.save!
	  c.calcula(instalacion)
	end
#	circuitos.select{|c| c.cargas.count == 0}.each do |c|
#	  raise "Circuitos sin cargas"
#	  logger.info "Circuito sin cargas #{c.id}"
#	end
#        circuitos.select{|c| c.cargas.count > 0}.each do |c|
#	  c.forro = forro
#	  c.canalizacion = canalizacion
#	  logger.info c.inspect
#          c.save!
#          c.calcula(instalacion)
#	end
	return instalacion
      end

      #Ensure that an installation has been calculated
      def ensure_instalacion
	  #raise "Estoy en ensure instalacion"
	  #Valores por defecto para el trafo    
	  self.skq ||= 500 #Esta es una suposición de Legrand aunque hay tablas de los cursos
  #	self.str ||= 75#Este dato se saca del Gis (En rodolfo Lenz 300)
	     #En emilio sanfuentes es 300, usar 315 para que pase la sanitizacion en el stock de tansformadores,
	  self.str ||= 315

	  #En Hernando de Aguirre con Lota, son 1000
	  self.uo  ||= 231
	  self.un  ||= 400
	  self.ucc ||= 4
	  self.largo ||= 5
	  
	  self.instalacion = D::Instalacion.new
	  self.instalacion.configurar(1,"",self.skq,self.str,self.un,self.uo,self.ucc,1,30,"TT")
	  logger.info "Iniciando una nueva instalacion en modelo presupuestos"
	  logger.info "Antes de llamar a tramo fijo"
	  self.instalacion.tramo_fijo#(@presupuesto)
	  logger.info "Despues de llamar a tramo fijo"
	  set_instalacion(self.instalacion)
	  @fuente = self.get_instalacion.find_by_nombre("SalidaTrafo")
	  raise "No se pudo encontrar Salida Trafo en presupuesto"  if @fuente.blank?
	  return instalacion
      end

      #Ensure that an user it is attended by the present project
      def crea_y_asigna_usuario
	   user = ::User.create(:name => self.name, :email => self.email, :password => self.fono, :password_confirmation => self.fono)
	   errors[:base] << user.errors.full_messages
	   errors[:base] << self.email
	   if user.save
	     usuario = Gestion::Usuario.create(:nombre => self.name, :email => self.email, :fono => self.fono, :activo => true,:user => user)
	     if usuario.save
	       self.usuario = usuario
	       return true
	     else
	       errors[:base] << "No se pudo crear usuario en presupuesto"
	       return false
	     end
	   else
	     errors[:base] << "No se pudo crear user en presupuesto"
	     return false
	   end
      end

      #Ensure that each project has an instalator and an admin
      def asigna_responsables
	if Instalador.first and Admin.first
	#El instalador escogido debe ser del tipo instalador, esto es con el campo type en instalador. Por eso cuando se asigne instalador en Usuario Edit debe cambiarse el campo type de User
	  self.instalador = Instalador.first unless self.instalador
	  self.admin = Admin.first
     
	  #self.save
	  return true
	end
      end
      #attr_accessor :instalacion

      #Put the diagrama unlineal calculation on the database on json format
      def set_instalacion(a_instalacion)
	#instalacion= a_instalacion #unless self.instalacion
	logger.info "Estoy en set_instalacion"
	logger.info a_instalacion.get_nodos.count.to_s if a_instalacion
	logger.info "numero de nodos........"
	self.instalacion = a_instalacion.to_json if a_instalacion
        logger.debug self.instalacion.inspect if a_instalacion
	logger.info "...................."
      end

      #Return the installation, created from its json representation
      def get_instalacion
	logger.info "Estoy en get instalacion"
	#logger.info "No se ha inicializado la instalacion" unless self.instalacion.class == D::Instalacion
        #ensure_instalacion unless (self.instalacion.class == D::Instalacion and self.instalacion.get_nodos.count > 1)
	begin
	   n = D::Instalacion.json_create self.instalacion
	
	rescue
          return nil
        end
	return n
      end

      #Return the instalacion and backed it on the class var instalacion
      def save_instalacion(a_instalacion)
	self.instalacion = a_instalacion
      end

      #Return the D2 Breaker and backed on the class var proteccionD2
      def set_proteccionD2(a_proteccionD2)
	self.proteccionD2 = a_proteccionD2
      end

      #Return the D2 Breaker
      def get_proteccionD2
	self.reload.proteccionD2
      end

      #Return the D1 Breaker and backed it to the class var proteccionD1
      def set_proteccionD1(a_proteccion_D1)
	self.proteccionD1 = a_proteccion_D1
      end

      #Return the D1 Breaker
      def get_proteccionD1
	self.reload.proteccionD1
      end



      #================ estados ==================
      #
      #
      #
      #Ensure levantamientos are setted on the behalf on auditorias of the project
      def ensure_levantamientos(arg)
	Electrico::MasterChecklist.all.each{ |m|
	    m.levantamientos.find_or_create_by(:presupuesto => self)
	}

	#Asegura que las auditorias tengan listos los cuestionarios para que el instalador los pueda responder en la etapa de levantamientos
	self.auditorias.each{|a|
	  #.checklist = Electrico::Checklist.create unless a.checklist
	  if a.checklists.any?
	    a.checklists.each{|c|
	      c.levantamientos.create!(:presupuesto => self) unless c.levantamientos.count > 0
	   }
	  end

	}
=begin
       Curso::Modulo.find_by_nombre("Instalaciones Eléctricas").pruebas.\
	 each{|p|
	 l = p.levantamientos.build(participante_id: self.usuario.id ,
				  presupuesto_id: self.id,
				       prueba_id: p.id );
				       p.save}
=end
      end

      #Ensure auditorias are initiated for each project
      def ensure_auditorias
      #Asegura que se creen todas las auditorías antes de llegar a la etap autidoria. De esa forma, el instaldor podrá borrar las que no necesite. Es más fácil que crear las que necesite
	#
	logger.info "Estoy en ensure auditorias"
	Gestion::TipoAuditoria.all.each do |t|
	  logger.info "Revisando si el tipo de auditoria #{t.id} #{t.nombre} no está ya referido por el presupuesto"

	  unless self.tipo_auditorias.ids.include?(t.id)
	    logger.info "El tipo de auditoría no está referida desde el presupuesto"
	    if self.usuario
	      a = Gestion::Auditoria.find_or_create_by({:tipo_auditoria_id => t.id, :presupuesto_id => self.id}) do |auditoria|
		logger.info "Creando auditoria para el tipo de auditoria #{t.id}"
		auditoria.presupuesto_id    = self.id
		auditoria.usuario = self.instalador.usuario
		logger.info "No existe user para el usuario" unless self.usuario.user
		auditoria.registro = self.usuario.user.crea_registro if self.usuario.user
	      end
	      logger.info "Se creó exitosamente la auditoria #{a.id}" if a and a.save
	    end
	    logger.info "La auditoria #{a.id} fue encontrada o creada, es sobre el tipo de auditoria #{a.tipo_auditoria.nombre}" if a and a.id
	  end
	end
	logger.info "Terminé en each que crea auditorias" 
	#Este método no puede finalizar con un llamad a logger. Impide el cambio de estado si se usa en Logging.logger['Electrico::Presupuesto'= :warn
	#Si se usa en Loggin.logger['Electrico::Presupuesto' = :info funciona bien
	#A lo que parece logger.info devuelve false si se usa en un level warn
	#Lo he comprado si uso return false
	return true
      end

      state_machine :estado ,initial: :inicio do
        logger = Logger.new(STDOUT)

        before_transition :any => :fin, :do => :crea_instalacion_de_una
        before_transition :materiales  => :auditoria, :do => :ensure_auditorias
        before_transition :auditoria => :levantamiento, :do => :ensure_levantamientos
        before_transition :legales   => :circuitos, :do => :ensure_instalacion

	around_transition do |presupuesto, transition, block|

	 #logger.info "Estoy en around transition en presupuesto"
	 #logger.info "============"
	 #logger.info presupuesto.descripcion
	 #logger.info presupuesto.direccion
	 #logger.info "===== estado ===="
	 #logger.info presupuesto.estado
	 #logger.info "================="
	 #logger.info transition.inspect
       #   start = Time.now.to_f
          if presupuesto.estado == "levantamiento" 
	     block.call #if presupuesto.respondido
          else
             block.call 
          end
	#  @tiempo_transcurrido ||= 0.00
	#  @tiempo_transcurrido += Time.now.to_f - start
	#  logger.info @tiempo_transcurrido
	end

	event :reset do
#	  logger.info "======= Estoy en evento reset de presupuesto"
#	  logger.info self.machine.methods.pretty_inspect
#	  logger.info "== estado"
	  transition :any => :inicio
	end

	event :proximo do
	  #	  
	  transition :inicio        => :visita
	  transition :visita        => :documentos
	  transition :documentos    => :legales
	  transition :legales       => :circuitos
	  transition :circuitos     => :materiales
          transition :materiales    => :auditoria
          transition :auditoria     => :levantamiento
	  transition :levantamiento => :cuestionarios
	  transition :cuestionarios => :mano_obra
	  transition :mano_obra     => :en_obra
	  transition :en_obra       => :fin
	  transition :fin           => :pago

	end
      

        event :retrocede do
#          logger.info "Estoy en evento retrocede de presupuesto"
      #    transition :medidor       => :inicio
          transition :visita        => :inicio
          transition :documentos    => :visita
          transition :legales       => :documentos
          transition :circuitos     => :legales
	  transition :materiales    => :circuitos

	  transition :auditoria     => :materiales
          transition :levantamiento => :auditoria
	  transition :cuestionarios => :levantamiento
	  transition :mano_obra     => :cuestionarios

          transition :en_obra       => :mano_obra
          transition :fin           => :en_obra
	  transition :pago          => :fin
        end

	state :inicio do
	 def avance
	   5
	 end
	end

	state :visita do
	 def avance
	   10
	 end
	end

        state :llamado do
         def avance
           15
         end
        end

        state :medidor do
         def avance
           20
         end
        end

        state :documentos do
         def avance
           25
         end
        end

	state :legales do
	 def avance
	   30
	 end
	end

        state :circuitos do
         def avance
           35
         end
        end

	state :materiales do
	  def avance
	    40
	  end
        end

        state :levantamiento do
          def avance
            45
          end
        end

	state :auditoria do
	  def avance
	    50
	  end
	end


	state :cuestionarios do
	  def avance
	    55
	  end
	end

	state :presupuesto do
	  def avance
	    60
	  end
	end

	state :mano_obra,:trabajando do
	 def avance
	   65
	 end
	end

	state :en_obra do
	 def avance
	   70
	 end
	end


	state :fin do
	 def avance
	   75
	 end
	end

	state :pago do
	  def avance
	    100
	  end
	end


      end #end state_machine

      #Main initialize of a prespuesto (project's budget)
      def initialize( attributes = {} )

#	logger.info "estoy en initialize de presupuestos"
#	logger.info "Estado es"
#	logger.info self.estado?
#	logger.info "==============="
#	logger.info "Atributos son:"
#	logger.info attributes.pretty_inspect
#	logger.info "==============="

        super
      end

      #Return true when all levantamientos are performed
      def respondido
	bandera = true
	res  =  self.levantamientos.each.inject(bandera){ |memo, levantamiento| memo and (levantamiento.updated_at > levantamiento.created_at)  }
	return res
      end

      #Perform manual and direct installation resseting
      def reset_instalacion
        sql_str = "update presupuestos set instalacion='{}' where id = #{self.id};"
	results = ElectricoBase.connection.execute(sql_str)
      end


private

      #Creates a nuew registro de user (a more forma representation for enterpirse users
      def crear_registro(user)
        Gestion::Registro.create(:nombre_fantasia => user.usuario.nombre, :razon_social => user.usuario.nombre, :direccion => presupuesto.direccion, :fono => user.fono, :email => user.email)
      end

      #Creates a new audiorias for this project, and current usuario.
      #it is called for some states of prespuesto
      def nueva_auditoria(a_tipo_auditoria_id)
        self.auditorias.create(
          :tipo_auditoria_id => a_tipo_auditoria_id,
          :presupuesto_id => self.id,
          :usuario_id => current_user.usuario.id,
          :registro_id => crear_registro(current_user).id
        )
      end


      #Append a new circuito by ussing << operator, to be consume by some algortimos on installation design
      def add_circuito(a_new_circuito_oop)
	self.circuitos << a_new_circuito_oop
      end

      #Return a remember token to be used on coookies when asked by some helper about current_project
      def create_remember_token
	self.remember_token = SecureRandom.urlsafe_base64
      end

      #Reset installation register after the last circuitos deleted
      def verifica_eliminacion(circuito)
       logger.debug "Estoy en presupuesto #{self.id} informando que se eliminado el circuito #{circuito.nombre}"
       #corriente_total = 0

	if circuitos.each.count  == 0
	  reset_instalacion 
	  logger.info "Instalacion se ha resetado"
	end
      end

      #Recalculate circuitos each time, installation it is modified
      def recalcula_circuitos(a_circuito)
       logger.debug "Estoy en recalcula_circuitos de presupuesto #{self.id} informando que se agregado el circuito #{a_circuito.nombre}"
#       logger.info "No hay instalacion" unless instalacion
=begin
       if $instalacion
	 coci_tablero = $instalacion.find_by_nombre("Coci en Tablero")

         $instalacion.get_nodos.each do |n|

	   if n.nombre.include?("Alimentador") and n.coci_maximo
	     n.coci_maximo.unset_fijo
	     n.coci_maximo.calcula
	   end
           if n.nombre.include?("Linea")  
	     #.coci_maximo.R = coci_tablero.R
	     #.coci_maximo.X = coci_tablero.X
	     
	     logger.info "============================="
	     logger.info "Recalculando coci maximo para "

             n.coci_maximo.unset_fijo
             n.coci_maximo.calcula

	     logger.info n.nombre
	     logger.info n.coci_maximo.nombre
	     logger.info n.coci_maximo.icc.to_s

             n.aguas_arriba.set_automatico 

	   end 
	   a_circuito.presupuesto.set_instalacion($instalacion)
         end
       end
=end
       #corriente_total = 0
       #'B3: Barra General en Tablero'
        self.largo ||= 5
       #
        #nstalacion = self.get_instalacion
	la_instalacion = self.get_instalacion
        if la_instalacion and la_instalacion.get_nodos.count > 3
	#  if instalacion
	    self.circuitos.each do |c|
	      unless c.id == self.id
		d3 = la_instalacion.get_automatico_D3(c.id)
		c.set_proteccionD3( d3 )   if d3.respond_to?('In') if c.largo
		c.recalcula if c.largo
		c.save! if c.largo
=begin
		d3 = instalacion.get_automatico_D3(c.id)
		if d3.respond_to?('In')
		  c.set_proteccionD3( d3 )
		  c.pick_automatico_D3( c, d3)
		  c.Ia =  d3.get_Im 
		  c.recalcula
		  #c.LMax = c.calculate_LMax(c.conductor,c.proteccionD3,c.ccto)
		  c.save!
		end
=end
	      end
	  #  end
	    self.set_instalacion(la_instalacion)
	    #self.save!
	  end
	end
       
      end


      #Set var pre-setting
      def defaulties
	self.realizado     = false
	self.pagado        = false
#	self.precio        = 25000
#	self.fecha_visita  = 3.hour.ago #En realidad quiero una hora despuest
	#self.formato_web  = "presupuestonada_web.html.erb"
	#self.formato_mail = "presupuestonada_mail.html.erb"
	#self.formato_pdf  = "presupuesto_nada.pdf"
	self.es_electricidad = true
	self.admin           = Admin.first unless Admin.count == 0
      ###  self.foto_id         = Domain.get_foto_id
	self.vigente         = true
	self.porllamar       = true
	self.Is              = 0
	self.P               = 0
	self.costo_circuitos = 0
	self.no_fases        = 1
	self.skq = 500
	self.str = 630
	self.un  = 400
	self.uo  = 231
	self.ucc = 4

      end

      #Former Var presseting, Obsoleto
      def x

=begin
	self.Is = 0
	self.P = 0
	self.costo_circuitos = 0

	sum_i = 0
	sum_p = 0
	sum_costo = 0

	f_diversidad = 0.6

	self.circuitos.each{ |c| c.destroy unless !TipoCircuito.find_by_id(c.tipo_circuito_id).nil? or !c.nombre.nil? }


	self.circuitos.each do |c|
      
	  t = TipoCircuito.find_by_id(c.tipo_circuito_id)
	  if  t.nombre != "Alimentador"    
	    c.materiales.each do |m|
	      sum_costo += m.costo unless m.costo.nil?
	    end
	    sum_i  += c.corriente_servicio unless c.corriente_servicio.nil?
	    sum_p  += c.carga_total unless c.carga_total.nil? 
	  else
	     c.materiales.each do |m|
	      sum_costo += m.costo unless m.costo.nil?
	     end
	  end
	end

	unless self.casa_habitacion
	  self.Is = sum_i * f_diversidad
	  self.P  = sum_p
	end
	self.costo_circuitos = sum_costo
=end
	unless self.te1_foto_id.nil?
	  foto = Electrico::Foto.find_by_id(self.te1_foto_id)
	  if !foto.nil?

	    self.te1_name = foto.tipo_contenido 
	    self.te1_url = foto.nombre_archivo

	    if foto.tipo_contenido == "application/pdf"
	      self.te1 = true
	    else
	      self.te1 = false
	    end
	  end
	end
      end
     
public

      #Fake this project as a Alimentador
      def nombre
	return "Alimentador"
      end

      #Fake this project as having a forro
      def forro
#	raise "Estoy en forro de presupuesto hay #{circuitos.count} circuitos, el forro del primero es #{circuitos.last.forro.inspect}"

	if circuitos.count > 0
          return circuitos.first.forro
	else
	  return nil
	end
      end

      #Fake this project as having max_spur
      def max_spur
	#El alimentador no puede tener bifurcaciones por norma, por lo que se asume igual al largo
	return self.largo
      end

    end
end

