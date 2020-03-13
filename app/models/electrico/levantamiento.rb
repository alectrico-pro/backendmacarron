class Electrico::Levantamiento < Curso::Examen


  belongs_to :checklist,    :class_name => "Electrico::Checklist"
  belongs_to :master_checklist, :class_name => "Electrico::MasterChecklist"


  belongs_to :presupuesto

 # validates :checklist, :presence => true
#  validates :mater_checklist, :presence => true

  #delegate usuario, to: :checklist,        if: :checklist.present?
  #delegate usuario, to: :master_checklist, if: :master_checklist.present?

  validates :presupuesto, :presence => true

  def calificar

    levantamiento = self
    prueba = levantamiento.checklist.present? ? levantamiento.checklist : levantamiento.master_checklist
    unless prueba and levantamiento.params
      return 0
    end
    respuestas_de_alternativas  = JSON.parse(levantamiento.params)
    if respuestas_de_alternativas.count == 0
      return 0
    end
    self.buenas = 0
    self.malas  = 0
    self.omitidas = 0

    prueba.preguntas.each do |pregunta|
      buenas_de_pregunta = 0
      malas_de_pregunta  = 0
      omitidas_de_pregunta = 0
      maxima_de_pregunta = Curso::Alternativa.all.select{|a| a.pregunta_id == pregunta.id and a.correcta?}.count
      respuestas_de_alternativas.each do |id_alternativa|
	alternativa = pregunta.alternativas.find_by(:id => id_alternativa )
	if alternativa
	  if alternativa.correcta?
	    self.buenas += 1
	    buenas_de_pregunta += 1
	  else
	    self.malas += 1
	    malas_de_pregunta += 1
	  end
	else
	  omitidas_de_pregunta +=1
	  self.omitidas +=1
	end
      end
      self.aprobado = true if buenas > 0 and (not malas > 0)
    end
    return 1 if self.aprobado
    return 0 unless self.aprobado
  end
end
