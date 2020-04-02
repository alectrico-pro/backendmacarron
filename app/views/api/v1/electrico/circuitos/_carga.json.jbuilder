if carga.id
  json.img  carga.tipo_equipo.img
  json.cantidad carga.cantidad
  json.delete_link dropFromCircuito_api_v1_electrico_circuito_url(carga)
  json.id carga.tipo_equipo.id
  json.nombre carga.tipo_equipo.nombre
  json.potencia carga.tipo_equipo.p 
  json.circuito carga.circuito.tipo_circuito.letras
  json.equipo carga.tipo_equipo.id
end


