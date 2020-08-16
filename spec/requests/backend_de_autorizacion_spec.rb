require 'rails_helper'

#Esta api es la de backend.alectrico.cl
#backend.alectrico.cl es el que crea usuarios y les dá al token de autorización
#También puede destruir al usuario

RSpec.describe 'Authenticate API', :type => 'request' do

  let(:return_params)  {  { :return => CFG[:authentication_endpoint_alectrico_url.to_s] } } 
  let(:retorno)        {               CFG[:authentication_endpoint_alectrico_url.to_s]  }
  let(:success_return) {               CFG[:retorno_exitoso_alectrico_url.to_s]   }

  if Ch::Check.malo(:herokuapp_backendalectrica)

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

      #llow(verificador_class).to receive(:new).with(valid_macarron).and_return(verificador)

      #allow(verificador).to receive(:get).and_return(true)
      #allow(verificador).to receive(:get_result).and_return(true)
    }
  end



  #Crea un token local que contiene un apuntador al reader de amp pages.
  #Idealmente el token sería suficiente por sí solo para permitir el acceso desde el microservicio al backend, pero en este caso, es interesante no romper la dinámica de las páginas amp. De forma que he terminado por mezclar ambos métodos de autorización.
  #Así que uso rid de AMP para crear registros en la base de datos.  
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

#La autenticación de las páginas amp se lleva a cabo llamando a authenticate cada vez que se refresque la página AMP. En authenticate se verifica que el origen sea el correcto y que la página entregue el token de autorización. Note que normalmente a las páginas AMP les bastaría con entregar el clientId y o el reader_id. Pero en mi caso, proceso todo eso y además verifico que el token local de autenticacioń apunte al reader.
  describe 'GET /authenticate' do
    context "Si recibe rid" do
      context "y recibe origen " do
	before { 
	  reader      = create(:reader)
          coded_token = JsonWebToken.encode(:reader_id => reader.id)
	  get "/authenticate", params:  {:rid => reader.rid,\
				  :__amp_source_origin => CFG[:frontend_alectrico_url.to_s] },\
				  headers: {  'Origin' => CFG[:frontend_alectrico_url.to_s] }
        }

	it 'Devuelve Token de authorization'  do
	  expect(json['auth_token']).to match(/ey/)
	end

	it 'Devuelve nada como mensaje' do
	  expect(json['loggedIn']).to be true
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

