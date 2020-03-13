json.extract! circuito, :corriente_servicio, :tipo_circuito
json.nombre circuito.tipo_circuito.nombre
json.nombre_abreviado circuito.tipo_circuito.nombre.truncate(10)
json.seguro circuito.corriente_servicio < circuito.tipo_circuito.capacidad
json.is_total @is_total


