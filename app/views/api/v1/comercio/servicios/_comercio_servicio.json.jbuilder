json.extract! comercio_servicio, :nombre, :id, :cantidad_disponible
json.disponible (not comercio_servicio.cantidad_disponible.nil? and comercio_servicio.cantidad_disponible > 0)
json.precio number_to_currency(comercio_servicio.precio, :precision => 0)
json.url servicio_path(comercio_servicio)
json.imagen code_image_servicio_path(comercio_servicio)
json.opinion comercio_servicio.opinion
json.estrellas comercio_servicio.estrellas
