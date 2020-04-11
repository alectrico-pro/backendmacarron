require 'rails_helper'

RSpec.describe 'Authenticate API', :type => 'request' do

  let(:return_params)  {{ :return => "https::/backend.alectrico.cl/authenticate"    }} 
  let(:retorno)        {  "https::/backend.alectrico.cl/authenticate"                }
  let(:success_return) {  "https::/backend.alectrico.cl/authenticate#success=true"   }

  #Crea un token local que contiene un apuntador al reader de amp pages.
  #Idealmente el token sería suficiente por sí solo para permitir el acceso desde el microservicio al backend, pero en este caso, es interesante no romper la dinámica de las páginas amp. De forma que he terminado por mezclar ambos métodos de autorización
  describe 'GET /create_token' do
    before {
      reader      = create(:reader)
      coded_token = JsonWebToken.encode(:reader_id => reader.id)
      get "/create_token", params:  {:clientId => "clientid",\
				     :rid => "amprid",\
				     :return => retorno }
      }

    it 'Devuelve código 302' do
      expect(response).to have_http_status(302)
    end

    it 'Se redirige a authenticate' do
      expect(response).to redirect_to(success_return)
    end

  end

  #La autenticación de las páginas amp se lleva a cabo llamando a authenticate cada vez que se refresque la página AMP. En authenticate se verifica que el origen sea el correcto y que la página entregue el token de autorización. Note que normalmente que a las páginas AMP les bastaría con entregar el clientId y o el reader_id. Pero en mi caso, proceso todo eso y además verifico que el token local de autenticacioń apunte al reader.
  describe 'GET /authenticate' do
    context "Si recibe rid" do
      context "y recibe origen " do
	before { 
	  reader = create(:reader)
          coded_token =JsonWebToken.encode(:reader_id => reader.id)
	  get "/authenticate", params:  {:rid => reader.rid,\
				  :__amp_source_origin => "https://frontend.alectrico.cl" },\
				  headers: {'Origin' => "https://frontend.alectrico.cl"} }

	it 'Devuelve Token de authorization'  do
	  skip
	  expect(json['auth_token']).to eq(coded_token)
	end

	it 'Devuelve nada como mensaje' do
	  skip
	  expect(response.body).to be_emtpy
	end

      end

      context "pero no recibe origen" do
	before {
	  reader = create(:reader)
	  get "/authenticate", params: {:rid => reader.rid }}

        it 'No devuelve token' do
	  expect(json['auth_token']).to eq(nil)
	end

	it 'Devuelve mensaje NotOriginAllowed' do
	  expect(response.body).to match(/NotOriginAllowed/)
	end

      end

    end
  end



  describe 'GET /destroy_reader' do

   before{
      reader = create(:reader)
      get "/destroy_reader", params: {:rid => reader.rid,\
				      :return => retorno}
    }

    it 'Hace redirection a CDN AMP y de vuelta a authenticate' do
      expect(response).to redirect_to(success_return)
    end

    it 'Devuelve Código 302' do
      expect(response).to have_http_status(302)
    end

  end

  describe 'GET /sign_in' do
    skip
  end

  describe 'GET /destroy_user' do
    skip
  end

end

