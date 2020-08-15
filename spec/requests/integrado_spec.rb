require 'rails_helper'
#authenticate es parte de la coreografía de las páginas AMP. Sirve para declarar si está logged_in o no. Eso es importante para que las páginas muestren contenido pertinente a las variables de accesso
RSpec.describe 'Items API', :type => 'request' do

  if Ch::Check.malo(:alectrica_autoriza)

    let (:access_key)        { double('AccessKey') }
    let (:access_key_class)  { class_double('AccessKey').as_stubbed_const(:transfer_nested_constants => true) }
    let (:verificador)       { double('RemoteVerifyMacarron') }
    let (:verificador_class) { class_double('RemoteVerifyMacarron').as_stubbed_const(:transfer_nested_constants => true) }

    before {
      allow(access_key).to receive(:get).and_return('eyii')
      allow(access_key_class).to receive(:new).with('amprid').and_return(access_key)
      allow(verificador_class).to receive(:new).with(valid_macarron).and_return(verificador)
      allow(verificador).to receive(:get).and_return(true)
      allow(verificador).to receive(:get_result).and_return(true)
    }

  end


  #Test suite integrando
  context "items con authenticación" do

    let(:return_params)  {{:rid => "amprid", :return => CFG[:authentication_endpoint_coronavid_url.to_s] } }
    let(:retorno)        { CFG[:authentication_endpoint_coronavid_url.to_s]   }    
    let(:success_return) { CFG[:retorno_exitoso_url.to_s] }
    let(:headers)        {{ "Origin" => CFG[:help_url.to_s]  }}

    let(:valid_macarron) { macarron = Macarron.new( location: CFG[:backend_coronavid_url.to_s],
                              identifier: 'w', 
                              key: ENV['SECRET_KEY_BASE'] ); 
                           macarron.add_first_party_caveat('LoggedIn = true') ; 
                           ms = macarron.serialize; 
                           return ms }

    describe 'GET /create_token' do
      before {
        get "/create_token", params: {:rid => "amprid", 
                                      :clientId => "clientId",\
			              :return => CFG[:authentication_endpoint_coronavid_url.to_s]}
      }

      it "to be redirect to retorno" do
        expect( response.body ).to redirect_to( CFG[:retorno_exitoso_url.to_s])
      end

      it "create Reader" do
        expect( Reader.count ).to eq(1)
      end

      it "not create User" do
	expect( User.count ).to eq(0)
      end

    end

    describe 'GET /authenticate after get_token' do
      before {

        get "/create_token",\
           params: {:rid => "amprid",\
            :clientId => "clientId", \
	    :return => CFG[:authentication_endpoint_coronavid_url.to_s]}

	get "/authenticate", params: {:rid => "amprid",\
	    :__amp_source_origin => CFG[:help_url.to_s] },\
	    headers: {'Origin' => CFG[:help_url.to_s]}
      }

      it 'return' do 
        expect(json['auth_token']).to match(/ey/)
      end

      it 'loggedIn true' do #Se puede dar loggin aunque no se cree un usuario
        expect(json['loggedIn']).to eq(true)
      end	

    end

    describe 'GET /contactos/create' do
      before {

        get "/create_token",\
       	params: {:rid => "amprid", :clientId => "clientId",\
	      :return => CFG[:authentication_endpoint_coronavid_url.to_s]}

        get "/authenticate",\
	  params: {:rid => "amprid",\
	  :__amp_source_origin => CFG[:help_url.to_s] },\
	  headers: {'Origin' => CFG[:help_url.to_s]}

	post "/contactos/create",\
	  params: {:rid => "amprid", :clientId => "clientId",\
	  :name => "Nombre", :email => "email@example.com",\
	  :fono => '987654321', :password => "clientId",\
	  :__amp_source_origin => CFG[:help_url.to_s]},\
	  headers: {'Origin' => CFG[:help_url.to_s]}
      } 

      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end

      it 'return nada' do
	expect(json['resultado']).to match(/Nombre/)
      end

      it 'create a user' do
	expect(User.count).to eq(1)
      end

      it 'existe a reader' do
	expect(Reader.count).to eq(1)
      end

      it 'el usuario debe tener un reader' do
	expect(User.first.readers.count).to eq(1)
      end

      it 'create a client' do
	expect(Client.count).to eq(1)
      end

      it 'el user debe tener un cliente' do
	expect(Reader.first.clients.count).to eq(1)
      end

      it 'los tres están relacionados, user,reader y client' do
	expect(Client.first.reader.user.name).to match(/Nombre/)
      end

    end


    describe 'GET /sign_in' do
      before {

        get "/create_token",\
          params: {:rid => "amprid", :clientId => "clientId",\
          :return => CFG[:backend_coronavid_url.to_s]}

        get "/authenticate", params: {:rid => "amprid",\
	  :__amp_source_origin => CFG[:help_url.to_s] },\
	  headers: {'Origin' => CFG[:help_url.to_s]}

        post "/contactos/create", params:\
	  {:rid => "amprid", :clientId => "clientId",\
	  :name => "Nombre", :email => "email@example.com",\
	  :fono => '987654321', :password => "123456",\
	  :__amp_source_origin => CFG[:help_url.to_s]},\
	  headers: {'Origin' => CFG[:help_url.to_s]}

        get  "/sign_in", params:\
	  {:rid => "amprid" , :return => retorno}
      }  

      it 'return code 302'  do  
        expect(response).to have_http_status(302)
      end 

      it "to be redirect to retorno" do
        expect(response.body).to\
	  redirect_to(CFG[:retorno_exitoso_url.to_s])
      end

    end 

    describe 'GET /authenticate despues de crear cliente' do
      before {

        get "/create_token",\
	  params: {:rid => "amprid", :clientId => "clientId",\
	  :return => CFG[:authentication_endpoint_coronavid_url.to_s]}

        get "/authenticate",\
	   params: {:rid => "amprid",\
	   :__amp_source_origin => CFG[:help_url.to_s] },\
	   headers: {'Origin' => CFG[:help_url.to_s]}

        post "/contactos/create",\
	  params: {:rid => "amprid", :clientId => "clientId",\
	  :name => "Nombre", :email => "email@example.com",\
	  :fono => '987654321', :password => "clientId",\
	  :__amp_source_origin => CFG[:help_url.to_s]},\
	  headers: {'Origin' => CFG[:help_url.to_s]}

        get  "/sign_in", params: {:rid => "amprid" , :return => retorno}

        get "/authenticate", params:\
	  {:rid => "amprid",\
	  :__amp_source_origin => CFG[:help_url.to_s] },\
	  headers: {'Origin' => CFG[:help_url.to_s]}
      }

      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end

      it "hay reader" do
        expect(Reader.count).to eq(1)
      end

      it "hay client" do
        expect(Client.count).to eq(1)
      end

      it "ya hay user" do
	expect(User.count).to eq(1)
      end

      it "están relaciones" do
	expect(Client.first.reader.user.name).to match(/Nombre/)
      end

      it "to be loggedIn" do
        expect(json['loggedIn']).to eq(true)
      end

    end

    describe 'GET /authenticate a pesar de nocrear cliente' do
      before {
        get "/create_token", params: {:rid => "amprid",\
				      :clientId => "clientId",\
				      :return => CFG[:authentication_endpoint_coronavid_url.to_s]}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
        get  "/sign_in", params: {:rid => "amprid" , :return => retorno}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
      }

      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end

      it "to be loggedIn" do
        expect(json['loggedIn']).to eq(true) 
      end

    end

    describe 'GET /authenticate a pesar de nocrear token ni cliente' do
      before {
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
        get  "/sign_in", params: {:rid => "amprid" , :return => retorno}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
      }

      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end

      it "to be loggedIn" do
        expect(json['loggedIn']).to eq(false) 
      end

    end



    describe 'GET /authenticate a pesar de nocrear token ni cliente ni authenticate' do
      before {
        get "/sign_in", params: {:rid => "amprid" , :return => retorno}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
      }

      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end

      it "to be logged out" do
        expect(json['loggedIn']).to eq(false) #La razón fundamental es que no se ha creado el token
      end

    end


    describe 'Se quiere eliminar la cuenta pero no desaparece el botón eliminar uenta. Debe usarse loggedIn false para ello. Esa es la tarea del authenticate.'do
      before {
        get  "/sign_in", params: {:rid => "amprid" , :return => retorno}
        get "/destroy_reader", params: {:rid => "amprid",:return => retorno }
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
      }

      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end

      it "to be logged out" do
        expect(json['loggedIn']).to eq(false) #La razón fundamental es que no se ha creado el token
      end

    end
    



    describe 'GET /authenticate no puede ser exitoso cuando hay un reaer ya logado, al autenticar a otro reader'  do
      before {

        allow(access_key_class).to receive(:new).with('amprid2').and_return(access_key)
        Reader.create!(:rid => "amprid2")

        get  "/sign_in", params: {:rid => "amprid2" , :return => retorno}

        Reader.create!(:rid => "amprid1")

        allow(verificador).to receive(:get).and_return(false)
        allow(verificador).to receive(:get_result).and_return(false)

        allow(access_key_class).to receive(:new).with('amprid1').and_return(access_key)
        allow(verificador).to receive(:get).and_return(false)
        allow(verificador).to receive(:get_result).and_return(false)


        get "/authenticate", params: {:rid => "amprid1",\
                                      :macarron_de_autorizacion => :valid_macarron,\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {  'Origin' => CFG[:help_url.to_s] }
      }

      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end

      it "to be loggedIn" do

        expect(json['loggedIn']).to eq(true) #No Se loga cuando ya exista otro reader. Esto es, el token es requisito para logarse, pero también lo es el user
      end

    end


    describe 'GET /authenticate no establece autenticación si el usuario no existe' do
      before {
        allow(access_key_class).to receive(:new).with('amprid2').and_return(access_key)
        #Lo que falta es la acción previa de login_reader
        get "/authenticate", params: {:rid => "amprid2",\
                                      :macarron_de_autorizacion => :valid_macarron,\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
      }

      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end

      it "to be loggedIn" do
        expect(json['loggedIn']).to eq(false) #No se acepta autenticación si el usuario no existe
      end

    end


    describe 'GET /destroy_reader' do
      before {
        get "/create_token", params: {:rid => "amprid", :clientId => "clientId",\
				      :return => CFG[:authentication_endpoint_coronavid_url.to_s]}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
        post "/contactos/create", params: {:rid => "amprid", :clientId => "clientId",\
					   :name => "Nombre", :email => "email@example.com",\
					   :fono => '987654321', :password => "123456",\
					   :__amp_source_origin => CFG[:help_url.to_s]},\
					   headers: {'Origin' => CFG[:help_url.to_s]}
        get  "/sign_in", params: {:rid => "amprid" , :return => retorno}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
        get "/destroy_reader", params: {:rid => "amprid",:return => retorno }
      }

      it 'return code 302'  do
        expect(response).to have_http_status(302)
      end

      it "to be redirect to retorno" do
        expect(response.body).to redirect_to(CFG[:retorno_exitoso_url.to_s])
      end

      it "destroy readr" do
        expect(Reader.count).to eq(0)
      end

    end


    describe "Todo el proceso" do
      before {
	#Esta es la integración de entrada
	#reader = create(:reader)
	#coded_token =JsonWebToken.encode(:reader_id => reader.id)
	get "/create_token", params: {:rid => "amprid", :clientId => "clientId", :return => retorno} 
        #Create token, crea un token para guardar el puntero a un reader. Para ello se debe crear antes el reader, el que quedará también indizado por rid. Tambíén se creará un cliente especificando su clientId
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
	#Atuthenticate usa el amprid para encontrar al reader y si existe lo considera válido,pero igual genera un token para guardar el puntero al reader
	post "/contactos/create", params: {:rid => "amprid", :clientId => "clientId",\
				    :name => "Nombre", :email => "email@example.com",\
				    :fono => '987654321', :password => "123456",\
				    :__amp_source_origin => CFG[:help_url.to_s]},\
				    :headers => headers
	#Encrypta es el botó submit de contactos create. El cual crea un usario nuevo y le asigna el reader actual (el cual se encuentra con amprid). También se intenta juntar al reader con el cliente (el que rresponde al indice clientId). En general hay una tríada user-reader-client
	get  "/sign_in", params: {:rid => "amprid" , :return => retorno}
	#El método de login usa el idenfiticador de reader para buscarlo en la base de datos, si lo encuentra le calcula el token para guardar e lpuntero reader.id
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
	#Finalmente authenticate ahora puede buscar al reader en la base de datos usando el puntero rid. Si lo encuentra, lo considera válido y genera un token para apuntar al reader. 
	#También averigua si token generado en la etapa previa permite encontrar el puntero del reader y por ende verificar que está en la base de datos.
	#Con esto puede emular un helper current_reader, cuya existencia se usa para decretar que es está en estado logado o loggedIn
	#Es importante saber qeu se devuelve el auth_token para que se pueda emplear en los comandos de contenido y poder authorizar cada request solo en base al token encriptado
	get "/destroy_reader", params: {:rid => "amprid",:return => retorno }
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => CFG[:help_url.to_s] },\
				      headers: {'Origin' => CFG[:help_url.to_s]}
      }

      it 'loggedIn=false' do
        expect(json['loggedIn']).to eq(false)
      end

    end
  end
end
