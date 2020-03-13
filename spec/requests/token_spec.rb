require 'rails_helper'

RSpec.describe 'Token encode y decode, olnly reader beacon', :type => 'request' do

  #Test suite integrando
  context "Funcionanmiento del token" do
    let(:return_params)  {{:rid => "amprid", :return => "https::/backend.alectrico.cl/authenticate" } }
    let(:retorno)        {"https::/backend.alectrico.cl/authenticate"              }    
    let(:success_return) {"https::/backend.alectrico.cl/authenticate#success=true"      }
    let(:headers)       {{ "Origin" => "https://frontend.alectrico.cl"  }}

    describe 'GET /create_token' do

      before {
	get "/create_token", params: {:rid => "amprid", :clientId => "clientId", :return => "https::/backend.alectrico.cl/authenticate"}
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
        get "/create_token", params: {:rid => "amprid", :clientId => "clientId", :return => "https::/backend.alectrico.cl/authenticate"}
	get "/authenticate", params: {:rid => "amprid", :__amp_source_origin => "https://frontend.alectrico.cl" }, headers: {'Origin' => "https://frontend.alectrico.cl"}
      }
      it 'return' do 
        expect(json['auth_token']).to match(/ey/)
      end

      it 'loggedIn false' do #No se puede dar loggin hasta que no se cree un usuario
        expect(json['loggedIn']).to eq(false)
      end	

      it 'get decoded well' do
	r = Reader.new
        reader_decoded= JsonWebToken.decode(json['auth_token'])['reader']
	#raise reader_decoded.to_json.inspect
	r.from_json(reader_decoded.to_json)
        expect( r.id).to match(1)
      end
    end
  end
end
