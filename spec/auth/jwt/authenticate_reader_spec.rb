#/spec/auth/authenticate_reader.rb

require 'rails_helper'

RSpec.describe AuthenticateReader do
  include ::Linea

  let(:reader)          { create(:reader) }
  let(:user)            { create(:user)}
  let(:valid_auth_obj)  { described_class.new(reader.rid) }

  describe '#call' do
    context 'when valid credentials' do
      it 'return valid token' do
	respuesta = valid_auth_obj.call
        token = respuesta.result
        decoded_token= JsonWebToken.decode(token)
        expect(decoded_token).not_to be_nil
        expect(decoded_token['circuito']).respond_to? 'nombre'
        #raise decoded_token.inspect



      end
    end
  end

  let(:invalid_auth_obj)  { described_class.new('no_rid') }

  describe '#call' do
    context 'when invalid credentials' do
      it 'do no return valid token' do
        expect{invalid_auth_obj.call}.to raise_error(InvalidCredentials::InvalidCredentials)
      end
    end
  end

end

