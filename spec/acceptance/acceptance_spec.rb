require 'rails_helper'
require 'rspec_api_documentation/dsl'

#Esta documentación explica cómo usar el bakend para almacenar en el modelo To Do (por hacer) y en el modelo  Circuitos
#Ambos deben estar protegidos usando CORS.
#Se requiere un macarrón que autorice al usuario que esté logado. El usuario que no lo esté, no podrá interactuar con Circuitos y con el modelo To Do.

resource "To Do" do
  explanation "La lista de tareas por hacer, usa items que se egregan a una lista to do"
  header "Origin", :__amp_source_origin
 
  parameter :macarron_de_autorizacion, "Macarrón de Autorización", :required => true
  parameter :auth_token, "Token de autorización", :required => true
  parameter :__amp_source_origin, "Origen de Amp Publisher", :required => true

  get '/todos' do

    let! (:todos)                   { create_list(:todo, 10) }
    let  (:todo_id)                 { todos.first.id }
    let! (:user)                    { create(:user)   }
    let! (:reader)                  { create(:reader,:user => user )  }
    let  (:auth_token)              { JsonWebToken.encode(reader: reader.as_json(:include => :user)) }
    let  (:__amp_source_origin)     { CFG[:help_url.to_s] }
    let  (:headers)                 {{ "Origin" => CFG[:help_url.to_s]  }}

    let(:macarron_de_autorizacion)  { macarron =Macarron.new( location: CFG[:backend_alectrica_url.to_s], identifier: 'w', key: ENV['SECRET_KEY_BASE'] );\
                                      macarron.add_first_party_caveat('LoggedIn = true');\
                                      ms= macarron.serialize; return ms }


  if Ch::Check.malo(:herokuapp_autorizador)

    let (:access_key)        { double('AccessKey') }
    let (:access_key_class)  { class_double('AccessKey').as_stubbed_const(:transfer_nested_constants => true) }
    let (:verificador)       { double('RemoteVerifyMacarron') }
    let (:verificador_class) { class_double('RemoteVerifyMacarron').as_stubbed_const(:transfer_nested_constants => true) }
    let (:verificador) { double('RemoteVerifyMacarron') }
    let (:verificador_class) { class_double('RemoteVerifyMacarron').as_stubbed_const(:transfer_nested_constants => true) }
    let (:access_key) { double('AccessKey') }
    let (:access_key_class) { class_double('AccessKey').as_stubbed_const(:transfer_nested_constants => true) }
    before {
      allow(access_key).to receive(:get).and_return('eyii')
      allow(access_key_class).to receive(:new).with('amprid').and_return(access_key)
      allow(verificador_class).to receive(:new).with(macarron_de_autorizacion).and_return(verificador)
      allow(verificador).to receive(:get).and_return(true)
      allow(verificador).to receive(:get_result).and_return(true)
    }
  end





    example "Devuelve una lista de las tareas", :document => false do
      explanation "Lista de tareas por hacer, To Do" 
      do_request
      expect(status).to eq(200)
    end

  end
end

resource "Circuitos" do
  explanation "Diseño de circuitos eléctricos"
  header "Origin", :__amp_source_origin

  parameter :macarron_de_autorizacion, "Macarrón de Autorización", :required => true
  parameter :auth_token, "Token de Autenticación", :required => true
  parameter :__amp_source_origin, "Origen de Amp Publisher", :required => true
  parameter :carga_id, "Identificación de la carga en Cargas Tree", :required => true
  parameter :circuito, "Identificación del tipo de Circuito en Cargas Tree", :required => true
  parameter :carga_qty, "Cantidad de Cargas"

  let! (:user)        {  create(:user)   }
  let! (:reader)      {  create(:reader, :user => user )  }
  let! (:instalacion) {  create(:instalacion) }
  #let! (:auth_token)  { JsonWebToken.encode( instalacion: instalacion.to_json , reader: reader.as_json(:include => :user)) }
 
  let  (:__amp_source_origin) { "http://192.168.137.190" }

  let(:macarron_de_autorizacion)    { macarron =Macarron.new( location: CFG[:backend_alectrica_url.to_s], identifier: 'w', key: ENV['SECRET_KEY_BASE'] ); macarron.add_first_party_caveat('LoggedIn = true') ; ms= macarron.serialize; return ms }
    

  let(:headers)       {{ "Origin" => CFG[:help_url.to_s]  }}



  if Ch::Check.malo(:herokuapp_autorizador)

    let (:access_key)        { double('AccessKey') }
    let (:access_key_class)  { class_double('AccessKey').as_stubbed_const(:transfer_nested_constants => true) }
    let (:verificador)       { double('RemoteVerifyMacarron') }
    let (:verificador_class) { class_double('RemoteVerifyMacarron').as_stubbed_const(:transfer_nested_constants => true) }
    let (:verificador) { double('RemoteVerifyMacarron') }
    let (:verificador_class) { class_double('RemoteVerifyMacarron').as_stubbed_const(:transfer_nested_constants => true) }
    let (:access_key) { double('AccessKey') }
    let (:access_key_class) { class_double('AccessKey').as_stubbed_const(:transfer_nested_constants => true) }
    before {
      allow(access_key).to receive(:get).and_return('eyii')
      allow(access_key_class).to receive(:new).with('amprid').and_return(access_key)
      allow(verificador_class).to receive(:new).with(macarron_de_autorizacion).and_return(verificador)
      allow(verificador).to receive(:get).and_return(true)
      allow(verificador).to receive(:get_result).and_return(true)
    }
  end




  post '/api/v1/electrico/circuitos/addToCircuito.json'   do
    let! (:auth_token)  { JsonWebToken.encode( instalacion: instalacion.to_json , reader: reader.as_json(:include => :user)) }
    let (:carga_id) { "100" }
    let (:circuito) { "I" }
    let (:carga_qty) { "5" }

    example "Agrega una carga a un circuito", :document => [:public]  do
      explanation "Busca el circuito y le agrega la carga seleccionada por el Usuario"
      do_request
      expect(status).to eq(200)
    end

  end

  get '/api/v1/electrico/circuitos/get.json' do

    let! (:auth_token)  { JsonWebToken.encode( instalacion: instalacion.to_json , reader: reader.as_json(:include => :user)) }

    example "Devuelve una lista de cargas ", :document => :public do
      explanation "Devuelve todas las cargas de una instalación eléctrica ordenadas en circuitos"
      do_request
      expect(status).to eq(200)
    end
  
  end

end
