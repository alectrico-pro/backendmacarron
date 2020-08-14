class Curso::Pregunta < ElectricoBase
  #attr_accessible :contenido_id, :enunciado, :puntaje, :tipo_id, :prueba_id, :explicacion,:alternativas_attributes

  #name_scope 'seleccionaruna', :conditions => {:tipo_id => '1'}
  #name_scope 'seleccionarvarias', :conditions => {:tipo_id => '2'}
  #name_scope 'verdaderofalso', :conditions => {:tipo_id => '3'}
  #usar en vistas 
  #preguntas.seleccionaruna.each do |preguntas|
  #...
  #end

  
  
  has_many :alternativas, dependent: :destroy
  has_many :respuestas, :through => :alternativas
 # has_many :respuestas
  #
  belongs_to :tema
  belongs_to :contenido
  belongs_to :tipo
  belongs_to :prueba #ojo

  belongs_to :gestion_criterio, :class_name => Gestion::Criterio
  #validates :puntaje, presence:true
  #validates :tipo_id, presence:true
  #validates :enunciado, presence:true
  

  accepts_nested_attributes_for :alternativas, :reject_if => lambda{|u| u[:enunciado].blank?}, :allow_destroy => true


end
