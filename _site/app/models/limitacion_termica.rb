  #Especifica los tres tipos de limitacion termica
  class LimitacionTermica
    def initialize(clase, esfuerzo_termico_maximo)
      @clase = clase
      @limitacion = esfuerzo_termico_maximo
    end

    def clase
      @clase
    end

    def esfuerzo_termico_maximo
      @limitacion
    end

  end

