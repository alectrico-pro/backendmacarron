class Instalador < User

  has_many :presupuestos, :class_name => "Electrico::Presupuesto"
end
