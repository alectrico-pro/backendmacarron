module Linea
  #La bitácora de los cálculos tiene un trato diferente en producción.
  #Se guarda en un registor del modelo circuito
  def reset_memoria
    $circuito_active_record_memoria =  Memo.new(self, true, "info") 
  end

  def logger
    Logging::Logger.new(self.class)
  end
  def linea
    Logging::Logger.new(self.class)
  end
  def memoria
    if not $circuito_active_record_memoria
      Logging::Logger.new(self.class)
    else
      $circuito_active_record_memoria
    end
  end
end

