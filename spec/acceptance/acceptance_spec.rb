require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "To Do" do
  explanation "La lista de tareas por hacer, usa items que se egregan a una lista to do"
  header "Origin", :__amp_source_origin

  parameter :auth_token, "Token de autorización", :required => true
  parameter :__amp_source_origin, "Origen de Amp Publisher", :required => true

  get '/todos' do

    let!(:todos)        {  create_list(:todo, 10) }
    let(:todo_id)       {  todos.first.id }

    let! (:user)        {  create(:user)   }
    let! (:reader)      {  create(:reader,:user => user )  }
    let (:auth_token) { JsonWebToken.encode(reader: reader.as_json(:include => :user)) }
    let (:__amp_source_origin) { "http://192.168.137.190" }

    example "Devuelve una lista de las tareas", :document => false do
      explanation "Lista de tareas por hacer, To Do" 
      do_request
      expect(status).to eq(200)
    end

  end
end

resource "Circuitos" do
  explanation "Preguntas de diseño sobre circuitos"
  header "Origin", :__amp_source_origin

  parameter :auth_token, "Token de autorización", :required => true
  parameter :__amp_source_origin, "Origen de Amp Publisher", :required => true
  parameter :carga_id, "Identificación de la carga en Cargas Tree", :required => true
  parameter :circuito, "Identificación del tipo de Circuito en Cargas Tree", :required => true


  let! (:user)        {  create(:user)   }
  let! (:reader)      {  create(:reader, :user => user )  }
  let! (:instalacion) {  create(:instalacion) }
  #let! (:auth_token)  { JsonWebToken.encode( instalacion: instalacion.to_json , reader: reader.as_json(:include => :user)) }
 
  let  (:__amp_source_origin) { "http://192.168.137.190" }


  post '/api/v1/electrico/circuitos/addToCircuito.json'   do
    let (:carga_id) { "844" }
    let (:circuito) { "I" }

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
