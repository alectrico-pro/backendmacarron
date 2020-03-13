json.items do
  json.array! @uno_solo do |e|
    json.values do
      json.array! @comercio_servicios, partial: 'api/v1/comercio/servicios/comercio_servicio', as: :comercio_servicio
    end
  end
end
