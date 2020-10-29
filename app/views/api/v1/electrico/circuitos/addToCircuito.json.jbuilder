hash= {"action": "addToCircuito.json.jbuilder", "cargas_count": @cargas ? @cargas.count : '' }
json.merge! hash

unless @circuito.errors.nil?
  hash = { "error":  @circuito.errors[:base] }
  json.merge! hash
end

hash = { "time_stamp": Time.now }
json.merge! hash

json.items do
  json.array! @cargas, partial: 'api/v1/electrico/circuitos/carga', as: :carga
end



