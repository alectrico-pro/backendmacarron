require 'rails_helper'

RSpec.describe 'Items API', :type => 'request' do

  #Test suite integrando
  context "items con authenticación" do
    let(:return_params)  {{:rid => "amprid", :return => "https::/backend.alectrico.cl/authenticate" } }
    let(:retorno)        {"https::/backend.alectrico.cl/authenticate"              }    
    let(:success_return) {"https::/backend.alectrico.cl/authenticate#success=true"      }
    let(:headers)       {{ "Origin" => "https://frontend.alectrico.cl"  }}

    describe 'GET /create_token' do

      before {
        get "/create_token", params: {:rid => "amprid", :clientId => "clientId",\
			      :return => "https::/backend.alectrico.cl/authenticate"}
      }
      it "to be redirect to retorno" do
        expect(response.body).to redirect_to("https::/backend.alectrico.cl/authenticate#success=true")
      end
      it "create Reader" do
        expect(Reader.count).to eq(1)
      end
      it "not create User" do
	expect(User.count).to eq(0)
      end
    end

    describe 'GET /authenticate after get_token' do
      before {

        get "/create_token",\
           params: {:rid => "amprid",\
            :clientId => "clientId", \
	    :return => "https::/backend.alectrico.cl/authenticate"}

	get "/authenticate", params: {:rid => "amprid",\
	    :__amp_source_origin => "https://frontend.alectrico.cl" },\
	    headers: {'Origin' => "https://frontend.alectrico.cl"}
      }
      it 'return' do 
        expect(json['auth_token']).to match(/ey/)
      end

      it 'loggedIn false' do #No se puede dar loggin hasta que no se cree un usuario
        expect(json['loggedIn']).to eq(false)
      end	
    end

    describe 'GET /contactos/create' do
      before {

        get "/create_token",\
       	params: {:rid => "amprid", :clientId => "clientId",\
	      :return => "https::/backend.alectrico.cl/authenticate"}

        get "/authenticate",\
	  params: {:rid => "amprid",\
	  :__amp_source_origin => "https://frontend.alectrico.cl" },\
	  headers: {'Origin' => "https://frontend.alectrico.cl"}

	post "/contactos/create",\
	  params: {:rid => "amprid", :clientId => "clientId",\
	  :name => "Nombre", :email => "email@example.com",\
	  :fono => '987654321', :password => "clientId",\
	  :__amp_source_origin => "https://frontend.alectrico.cl"},\
	  headers: {'Origin' => "https://frontend.alectrico.cl"}
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
          :return => "https::/backend.alectrico.cl/authenticate"}

        get "/authenticate", params: {:rid => "amprid",\
	  :__amp_source_origin => "https://frontend.alectrico.cl" },\
	  headers: {'Origin' => "https://frontend.alectrico.cl"}

        post "/contactos/create", params:\
	  {:rid => "amprid", :clientId => "clientId",\
	  :name => "Nombre", :email => "email@example.com",\
	  :fono => '987654321', :password => "123456",\
	  :__amp_source_origin => "https://frontend.alectrico.cl"},\
	  headers: {'Origin' => "https://frontend.alectrico.cl"}

        get  "/sign_in", params:\
	  {:rid => "amprid" , :return => retorno}
      }  

      it 'return code 302'  do  
        expect(response).to have_http_status(302)
      end 

      it "to be redirect to retorno" do
        expect(response.body).to\
	  redirect_to("https::/backend.alectrico.cl/authenticate#success=true")
      end

    end 

    describe 'GET /authenticate despues de crear cliente' do
      before {

        get "/create_token",\
	  params: {:rid => "amprid", :clientId => "clientId",\
	  :return => "https::/backend.alectrico.cl/authenticate"}

        get "/authenticate",\
	   params: {:rid => "amprid",\
	   :__amp_source_origin => "https://frontend.alectrico.cl" },\
	   headers: {'Origin' => "https://frontend.alectrico.cl"}

        post "/contactos/create",\
	  params: {:rid => "amprid", :clientId => "clientId",\
	  :name => "Nombre", :email => "email@example.com",\
	  :fono => '987654321', :password => "clientId",\
	  :__amp_source_origin => "https://frontend.alectrico.cl"},\
	  headers: {'Origin' => "https://frontend.alectrico.cl"}

        get  "/sign_in", params: {:rid => "amprid" , :return => retorno}

        get "/authenticate", params:\
	  {:rid => "amprid",\
	  :__amp_source_origin => "https://frontend.alectrico.cl" },\
	  headers: {'Origin' => "https://frontend.alectrico.cl"}
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
				      :return => "https::/backend.alectrico.cl/authenticate"}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
        get  "/sign_in", params: {:rid => "amprid" , :return => retorno}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
      }
      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end
      it "to be loggedIn" do
        expect(json['loggedIn']).to eq(false) #No se debe logar porque falta el usuario
      end
    end

    describe 'GET /authenticate a pesar de nocrear token ni cliente' do
      before {
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
        get  "/sign_in", params: {:rid => "amprid" , :return => retorno}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
      }
      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end
      it "to be loggedIn" do
        expect(json['loggedIn']).to eq(nil) #no debe logarse si no se ha creado el token, o más bien el reader que responde al token
      end
    end



    describe 'GET /authenticate a pesar de nocrear token ni cliente ni authenticate' do
      before {
        get  "/sign_in", params: {:rid => "amprid" , :return => retorno}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
      }
      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end
      it "to be logged out" do
        expect(json['loggedIn']).to eq(nil) #La razón fundamental es que no se ha creado el token
      end
    end


    describe 'Se quiere eliminar la cuenta pero no desaparece el botón eliminar uenta. Debe usarse loggedIn false para ello. Esa es la tarea del authenticate.'do
      before {
        get  "/sign_in", params: {:rid => "amprid" , :return => retorno}
        get "/destroy_reader", params: {:rid => "amprid",:return => retorno }
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
      }
      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end
      it "to be logged out" do
        expect(json['loggedIn']).to eq(nil) #La razón fundamental es que no se ha creado el token
      end
    end
    



    describe 'GET /authenticate a pesar de nocrear token ni cliente ni authenticate, pero con otro reader'  do
      before {
        otro_reader_existente = Reader.create!(:rid => "amprid2")
        get  "/sign_in", params: {:rid => "amprid2" , :return => retorno}
        get "/authenticate", params: {:rid => "amprid2",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
      }
      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end
      it "to be loggedIn" do
        expect(json['loggedIn']).to eq(false) #No Se loga cuando ya exista otro reader. Esto es, el token es requisito para logarse, pero también lo es el user
      end
    end


    describe 'GET /authenticate a pesar de nocrear token ni cliente ni authenticate, pero con otro reader, y sin sign_in previo' do
      before {
        get "/authenticate", params: {:rid => "amprid2",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
      }
      it 'return code 200'  do
        expect(response).to have_http_status(200)
      end
      it "to be loggedIn" do
        expect(json['loggedIn']).to eq(nil) #No se acepta autenticación si el usuario no existe
      end
    end



    describe 'GET /destroy_reader' do
      before {
        get "/create_token", params: {:rid => "amprid", :clientId => "clientId",\
				      :return => "https::/backend.alectrico.cl/authenticate"}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
        post "/contactos/create", params: {:rid => "amprid", :clientId => "clientId",\
					   :name => "Nombre", :email => "email@example.com",\
					   :fono => '987654321', :password => "123456",\
					   :__amp_source_origin => "https://frontend.alectrico.cl"},\
					   headers: {'Origin' => "https://frontend.alectrico.cl"}
        get  "/sign_in", params: {:rid => "amprid" , :return => retorno}
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
        get "/destroy_reader", params: {:rid => "amprid",:return => retorno }
      }

       it 'return code 302'  do
         expect(response).to have_http_status(302)
       end
       it "to be redirect to retorno" do
         expect(response.body).to redirect_to("https::/backend.alectrico.cl/authenticate#success=true")
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
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
	#Atuthenticate usa el amprid para encontrar al reader y si existe lo considera válido,pero igual genera un token para guardar el puntero al reader
	post "/contactos/create", params: {:rid => "amprid", :clientId => "clientId",\
				    :name => "Nombre", :email => "email@example.com",\
				    :fono => '987654321', :password => "123456",\
				    :__amp_source_origin => "https://frontend.alectrico.cl"},\
				    :headers => headers
	#Encrypta es el botó submit de contactos create. El cual crea un usario nuevo y le asigna el reader actual (el cual se encuentra con amprid). También se intenta juntar al reader con el cliente (el que rresponde al indice clientId). En general hay una tríada user-reader-client
	get  "/sign_in", params: {:rid => "amprid" , :return => retorno}
	#El método de login usa el idenfiticador de reader para buscarlo en la base de datos, si lo encuentra le calcula el token para guardar e lpuntero reader.id
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
	#Finalmente authenticate ahora puede buscar al reader en la base de datos usando el puntero rid. Si lo encuentra, lo considera válido y genera un token para apuntar al reader. 
	#También averigua si token generado en la etapa previa permite encontrar el puntero del reader y por ende verificar que está en la base de datos.
	#Con esto puede emular un helper current_reader, cuya existencia se usa para decretar que es está en estado logado o loggedIn
	#Es importante saber qeu se devuelve el auth_token para que se pueda emplear en los comandos de contenido y poder authorizar cada request solo en base al token encriptado
	get "/destroy_reader", params: {:rid => "amprid",:return => retorno }
        get "/authenticate", params: {:rid => "amprid",\
				      :__amp_source_origin => "https://frontend.alectrico.cl" },\
				      headers: {'Origin' => "https://frontend.alectrico.cl"}
       }

     it 'loggedIn=false' do
       expect(json['loggedIn']).to eq(nil)
     end
    end
  end
end
