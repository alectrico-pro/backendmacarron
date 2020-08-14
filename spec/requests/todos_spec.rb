require 'rails_helper'

#Este recurso es ofrecido por el backend y no por un microservicio. Usa un macarrón de autorización validado por un servidor de autorización remota
#Es un recurso normal, y solo hay que proveerlos los parámetros adecuados de autorización.
#Observar que usa un token de autorización que incluye un objeto reader serializado json
#Entonces, este recurso es una api en este servidor que es autorizada por el autorizador.
#Este API está protegido por el autorizador de alectrica. 
RSpec.describe 'Todos API', type: :request do

  let!(:todos)         {  create_list(:todo, 10) }
  let(:todo_id)        {  todos.first.id }
  let(:user)           {  create(:user)   }
  let(:reader)         {  create(:reader, :user => user )  }
  let(:coded_token)    {  JsonWebToken.encode( reader: reader.as_json(:include => :user)) }
  let(:valid_macarron) {  macarron =  Macarron.new( location: CFG[:autorizador_alectrica_url.to_s], identifier: 'w', key: ENV['SECRET_KEY_BASE'] );\
        macarron.add_first_party_caveat('LoggedIn = true');\
        ms= macarron.serialize;\
        return ms }
  let(:headers)        {{ "Origin" => CFG[:help_url.to_s]  }}
  let(:valid_params)   {{ :__amp_source_origin => CFG[:help_url.to_s],\
                          :auth_token => coded_token,\
                          :macarron_de_autorizacion => valid_macarron  }}
   
  #Test suit for GET /todos
  #Index
   describe 'GET /todos' do
    #make HTTP get request before each example
    before { get '/todos', params: valid_params, headers: headers }

    it 'returns todos' do
      #Note 'json' is a custom helper to parse JSON responses
      #está en el directorio support que debe ser configurado para cargarlo en rails_helper
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
   end

  #Test suite for GET /todos/:id
  #Show
  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}", params: valid_params, headers: headers }
    
    context "when the record exists" do
      it 'returns the todo' do
	expect(json).not_to be_empty
	expect(json['id']).to eq(todo_id)
      end
      
      it 'returns status code 200' do
	expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) {100}

      it 'returns status code 404' do
	expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
	expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  #Test suite for POST /todos
  #Create
  describe 'POST /todos' do
    #valid payload
    let(:valid_attributes) {{title: 'Learn Elm', created_by: '1'}}

    context 'when the request is valid' do
      before {post '/todos', params: valid_params.merge(valid_attributes), headers: headers }


      it 'creates a todo' do
	expect(json['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
	expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/todos', params: valid_params.merge({ title: 'Foobar' }), headers: headers }

      it 'returns status code 422' do
	expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
	expect(response.body)
	.to match(/La validación falló: Created by no puede estar en blanco/)
      end
    end
  end

  #Test suite for PUT /todos/:id
  #Update
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: 'Shopping' }}

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_params.merge( valid_attributes), headers: headers }

      it 'updates the record' do
	expect(response.body).to be_empty
      end

      it 'returns status code 204' do
	expect(response).to have_http_status(204)
      end
    end

  end

  #Test suit for DELETE /todos/:id
  #Delete
  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}", params: valid_params, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
