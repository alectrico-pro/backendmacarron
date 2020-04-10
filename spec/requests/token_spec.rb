require 'rails_helper'

RSpec.describe 'Token encode y decode, olnly reader beacon', :type => 'request' do

  #Test suite integrando
  context "Funcionanmiento del token" do
    let(:return_params)  {{:rid => "amprid", :return => "https::/backend.coronavid.cl/authenticate" } }
    let(:retorno)        {"https::/backend.coronavid.cl/authenticate"              }    
    let(:success_return) {"https::/backend.coronavid.cl/authenticate#success=true"      }
    let(:headers)       {{ "Origin" => "https://help.coronavid.cl"  }}

    describe 'GET /create_token' do

      before {
	get "/create_token", params: {:rid => "amprid", :clientId => "clientId", :return => "https::/backend.coronavid.cl/authenticate"}
      }
      it "to be redirect to retorno" do
        expect(response.body).to redirect_to("https::/backend.coronavid.cl/authenticate#success=true")
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
       get "/create_token", params: {:rid => "amprid", :clientId => "clientId", :return => "https::/backend.coronavid.cl/authenticate"}
       get "/authenticate", params: {:rid => "amprid", :__amp_source_origin => "https://help.coronavid.cl" }, headers: {'Origin' => "https://help.coronavid.cl"}
      }
      it 'return' do 
        expect(json['auth_token']).to match(/ey/)
      end

      it 'loggedIn true' do #Se puede dar loggin aunque no se cree un usuario
        expect(json['loggedIn']).to eq(true)
      end	

      it 'get decoded well' do
        rid = JsonWebToken.decode(json['auth_token'])['rid']
        expect( rid).to match("amprid")
      end
    end
  end
end
