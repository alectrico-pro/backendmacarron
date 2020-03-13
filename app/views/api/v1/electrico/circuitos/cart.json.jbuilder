hash= { "cargas_count": @cargas.count}
json.merge! hash

hash = { "presupuesto": @presupuesto.id }
json.merge! hash

hash = { "dueño": @presupuesto.usuario ? @presupuesto.usuario.nombre : "sin usuario" }
json.merge! hash

hash = { "current_user": user_signed_in? ? current_user.name : "sin current_user" }
json.merge! hash

hash = { "time_stamp": Time.now }

json.merge! hash


json.items do
  json.array! @cargas, partial: 'api/v1/electrico/circuitos/carga', as: :carga
end

