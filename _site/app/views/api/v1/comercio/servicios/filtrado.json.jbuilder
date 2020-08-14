hash= { "filtro": @filtro}
json.merge! hash
json.items do
  json.array! @comercio_servicios, partial: 'api/v1/comercio/servicios/comercio_servicio', as: :comercio_servicio
end
