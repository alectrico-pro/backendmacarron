
#hash= { "subtotal" => 1}
#json.merge! hash
json.items do
  json.child! do
    json.subtotal         number_to_currency( @orden.subtotal,       :precision => 0)
    json.total_en_pesos   number_to_currency( @orden.total_peso,     :precision => 0)
#    json.total_en_dolares number_to_currency( @orden.total_dolar,    :precision => 2)
 #   json.valor            number_to_currency( @orden.valor_dolar,    :precision => 2)
 #   json.fecha                                 @orden.fecha_dolar
    json.a_domicilio      number_to_currency( @orden.a_domicilio,    :precision => 0)
  end
end



