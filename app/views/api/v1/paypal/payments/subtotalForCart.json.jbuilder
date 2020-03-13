
#hash= { "subtotal" => 1}
#json.merge! hash
json.items do
  json.child! do
    json.subtotal number_to_currency(@orden.subtotal,:precision => 0)
    json.total    number_to_currency(@orden.total, :precision => 0)
  end
end



