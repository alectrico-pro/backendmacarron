class D::Repartidor < Proteccion 

  def initialize(a_standard,a_In,a_modelo,a_tension,a_formato,a_Icw,a_Ipk,a_no_polos,a_T,a_montaje,a_Ui,a_no_modulos,a_arreglo_bornes,a_referencia)
    super(a_In,a_modelo,a_tension,a_formato,a_referencia)
    @referencia = a_referencia
    @no_modulos = a_no_modulos
    @arreglo_bornes = a_arreglo_bornes
    @tension = a_tension
    @standard = a_standard
    @Icw = a_Icw
    @Ipk = a_Ipk
    @polos = a_no_polos
    @T = a_T
    @montaje = a_montaje
    @Ui = a_Ui
  end

  def no_modulos
    @no_modulos
  end

  def referencia
    @referencia
  end

  def bornes
    @arreglo_bornes
  end

  def Ui
    @Ui
  end

  def puts
    memoria.info "Estoy en puts de Repartidor"
  end

  def Ipk
    @Ipk
  end

  def cumple_polos?(a_no_polos)
    @polos >= a_no_polos
  end

  def cumple_In?(a_is,a_iz)
    @Is=a_is
    @Iz=a_iz
    if (@In >= a_is and a_iz > a_is )
      return true
    else
      return false
    end
  end
 
end
