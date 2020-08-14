require 'rails_helper'

RSpec.describe 'MicroServicio help accesa el backend de autorización: No usa macarron, solo usa reader: ', :type => 'request' do

  #Test suite integrando
  context "Funcionamiento del token:" do

    let(:return_params)  {{:rid => "amprid", :return => CFG[:authentication_endpoint_coronavid_url.to_s] } }
    let(:retorno)        {                              CFG[:authentication_endpoint_coronavid_url.to_s] }    
    let(:success_return) {                              CFG[:retorno_exitoso_url.to_s] }
    let(:headers)        {{                 "Origin" => CFG[:help_url.to_s] }}


    #Al crear el token, se crea un reader si antes no existía, pero igual se verifica lo mismo en authenticate de forma que siempre habrá un reader cuando haya un token. El Usuario debe ser creado explícitamente por el usuario llenando un formulario de registro.
    describe 'GET /create_token' do

      before {
	get "/create_token", params: {:rid => "amprid", :clientId => "clientId", :return => CFG[:authentication_endpoint_coronavid_url.to_s]}
      }
      it "to be redirect to retorno" do
        expect(response.body).to redirect_to( CFG[:retorno_exitoso_url.to_s] )
      end
      it "create Reader" do
        expect(Reader.count).to eq(1)
      end
      it "not create User" do
	expect(User.count).to eq(0)
      end
    end

    #Después de creado el token se decreta que está logado, no es necesario que el usuario esté creado
    describe 'GET /authenticate after get_token' do
      before {
       get "/create_token", params: {:rid => "amprid", :clientId => "clientId", :return => CFG[:authentication_endpoint_coronavid_url.to_s]}
       get "/authenticate", params: {:rid => "amprid", :__amp_source_origin => CFG[:help_url.to_s] }, headers: {'Origin' => CFG[:help_url.to_s]}
      }
      it 'return' do 
        expect(json['auth_token']).to match(/ey/)
      end

      it 'loggedIn true' do #Se puede dar loggin aunque no se cree un usuario
        expect(json['loggedIn']).to eq(true)
      end	

      it 'devuelve error' do
        expect{ JsonWebToken.decode(json['auth_token'])['rid'] }.to raise_error(ExceptionHandler::InvalidToken )
      end
    end
  end
end
