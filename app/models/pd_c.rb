#---------------------------------------------
#Guarda el poder de corte para uso industrial y domestico
class PdC

  def self.json_create(o)
    attrs = JSON.parse(o)
    PdC.new(attrs['domiciliario'], attrs['industrial'], attrs['ics'])
  end

  def initialize(domiciliario,industrial,ics)
    @industrial = industrial
    @domiciliario = domiciliario
    @ics = ics #Creo que es corriente de cortoricuito secundaria que es la corriente de cortoricuito que se genera cuando la protección se usa para energizar un circuito que ya está en corte.
  end

  def ics
   return @ics
  end

  def norma_industrial
    return @norma_industrial
  end

  def norma_domiciliaria
    return @norma_domiciliaria
  end

  def industrial #en kiloAmperes
    return @industrial
  end

  def domiciliario #em Amperes
    return @domiciliario
  end

end
