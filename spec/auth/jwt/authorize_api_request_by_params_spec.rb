#spec/auth/authorize_api_request_by_params
require 'rails_helper'

RSpec.describe AuthorizeApiRequestByParams do

  let(:circuito)                 {   create(:circuito) }
  #Definir algún usuario existente en la base de datos
  let(:invalid_reader)           {   create(:reader) }
  let(:invalid_params)           {{ "auth_token" => token_generador( invalid_reader, circuito )} }

  subject(:invalid_request_obj)  {   described_class.new(invalid_params) }

  #Genera un token para un reader y usuario válidos
  let(:valid_user)               {   create(:user) }
  let(:valid_reader)             {   create(:reader, :user => valid_user) }
  let(:valid_params)             {{ "auth_token" => token_generador( valid_reader, circuito )} }

  subject(:valid_request_obj)    {   described_class.new(valid_params) }

  describe '#call' do
    context 'when invalid request' do
      it 'raise an error' do
        #$$expect{ raise StandardError }.to raise_error(StandardError)
        #result = valid_request_obj.call.result	
	expect{ invalid_request_obj.call }.to raise_error(ExceptionHandler::InvalidToken)
#        expect(result).to eq(reader)
      end
    end

    context 'when valid request' do
      it 'return reader objet' do
        expect(valid_request_obj.call.result).to eq(valid_user)
      end
    end
  end
end
