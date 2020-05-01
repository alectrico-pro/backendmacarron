#spec/auth/authorize_api_request_by_params
require 'rails_helper'

RSpec.describe AuthorizeApiRequestByParams do

  let(:circuito)                 {  create(:circuito) }
  #Definir algún usuario existente en la base de datos
  let(:invalid_reader)           {  create(:reader) }
  let(:valid_macarron)           {  macarron =Macarron.new( 
                                       location: 'http://backend.alectrica.cl',
                                       identifier: 'w', key: ENV['SECRET_KEY_BASE'] );
                                    macarron.add_first_party_caveat('LoggedIn = true') ; 
                                    ms = macarron.serialize; 
                                    return ms }
  #Esto llama a un procedimiento en el servidor de autorización
  let!(:invalid_access_key)      { AccessKey.new("-1").get }

# let(:invalid_params)           {{ "auth_token" => token_generador( invalid_reader, circuito ), "macarron_de_autorizacion" => valid_macarron }}
  let(:invalid_params)           {{ "auth_token" => invalid_access_key,
                                    "macarron_de_autorizacion" => valid_macarron }}

  subject(:invalid_request_obj)  {   described_class.new(invalid_params) }

  #Genera un token para un reader y usuario válidos
  let(:valid_user)               {   create(:user) }
  let(:valid_reader)             {   create(:reader, :user => valid_user) }
  let(:valid_params)             {{ "auth_token" => token_generador( valid_reader ), "macarron_de_autorizacion" => valid_macarron } }

  subject(:valid_request_obj)    {   described_class.new(valid_params) }

  describe '#call' do
    context 'when invalid request' do

      it 'raise an error' do
        #$$expect{ raise StandardError }.to raise_error(StandardError)
        #result = valid_request_obj.call.result	
	expect{ invalid_request_obj.call }.to raise_error(NotReader::NotReader)
#        expect(result).to eq(reader)
      end

    end

    context 'when valid request' do

      it 'return reader objet' do
        expect(valid_request_obj.call.result).to eq(valid_reader)
      end

    end

  end
end
