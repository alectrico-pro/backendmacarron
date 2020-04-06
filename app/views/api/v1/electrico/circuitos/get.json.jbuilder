json.merge! @circuito

hash= { "potencia_total_industrial": number_with_delimiter(@potencia_total_industrial.round(0), :delimiter => '.',:unit => "W" )  }
json.merge! hash

hash= { "potencia_total_domiciliaria": number_with_delimiter(@potencia_total_domiciliaria.round(0),:delimiter => '.') }
json.merge! hash

hash= { "is_total": number_to_currency(@is_total,:precision => 0,:unit => "") }
json.merge! hash

hash = { "potencia_instalada": number_with_delimiter(@potencia_instalada.round(0), :delimiter => '.') }
json.merge!  hash

hash = { "empalme_soterrado_sugerido": @empalme_soterrado_sugerido }
json.merge! hash

hash = { "empalme_aereo_sugerido": @empalme_aereo_sugerido }
json.merge! hash


hash = { "empalme_sugerido": true }
json.merge! hash

hash = { "fp_minimo": number_to_currency(@fp_minimo,:precision =>2, :unit => "") }
json.merge! hash


hash= { "cargas_count": @cargas.count}
json.merge! hash

hash = { "current_reader": current_reader.try(:id) }
json.merge! hash

hash = { "time_stamp": Time.now }
json.merge! hash

json.items do
  json.array! @cargas, partial: 'api/v1/electrico/circuitos/carga', as: :carga
end

