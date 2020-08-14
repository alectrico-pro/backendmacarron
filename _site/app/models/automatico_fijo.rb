class AutomaticoFijo < AutomaticoRegulable


  def initialize(poder_de_corte, calibre, modelo,caja,a_gama, a_voltaje = 220)
    super(poder_de_corte, calibre, modelo,a_voltaje, caja)
    @minima_regulacion_del_termico_per_design=1
    @gama = a_gama
    if modelo.include?('DRX 125')
    
      if calibre >= 40 and calibre <= 125
	self.n_magnetico_fijo = 10
      elsif calibre==32
	self.n_magnetico_fijo = 12.5
      elsif calibre==30
	self.n_magnetico_fijo = 13.3
      elsif calibre==25
	self.n_magnetico_fijo = 16
      elsif calibre==20
	self.n_magnetico_fijo = 20
      elsif calibre==16
	self.n_magnetico_fijo = 25
      elsif calibre==15
	self.n_magnetico_fijo = 26
      end

    elsif modelo.include?('DRX 250')
    
      if  calibre == 125
        self.n_magnetico_fijo = 5
      elsif calibre == 250
        self.n_magnetico_fijo = 10
      end

    elsif modelo.include?('DRX 630')

      self.n_magnetico_fijo = 10

    end



    self.set_industrial
  end

  def gama
    @gama
  end

  def regulacion
    1
  end

  def set_domiciliario
  end

  def Ii
    @Im
  end

end
