json.items do
  json.array! @circuitos, partial: 'api/v1/electrico/circuitos/circuito', as: :circuito
end

