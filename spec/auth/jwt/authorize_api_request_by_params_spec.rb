#spec/auth/authorize_api_request_by_params
require 'rails_helper'

#Este tipo de autorización, está implementada en el backend, consiste en revisar si en los parámetros hay un token de acceso al bakend y un macarrón de autorización entregado por un autorizador remoto.
#El macarrón se obtiene desde el servidor de autorización o puede ser generado localmente para pruebas, usando AccessKey.new
RSpec.describe AuthorizeApiRequestByParams do

  let(:circuito)                 {  create(:circuito) }
  #Definir algún usuario existente en la base de datos
  let(:invalid_reader)           {  create(:reader) }
  let(:valid_macarron)           {  macarron =Macarron.new( 
                                       location: CFG[:backend_alectrica_url.to_s],
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
  let(:valid_params)             {  { "auth_token" => token_generador( valid_reader ), "macarron_de_autorizacion" => valid_macarron } }

  if Ch::Check.malo(:alectrica_autoriza)

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
      allow(verificador_class).to receive(:new).with(valid_macarron).and_return(verificador)
      allow(verificador).to receive(:get).and_return(true)
      allow(verificador).to receive(:get_result).and_return(true)
    }
  end




  subject(:valid_request_obj)    {   described_class.new(valid_params) }

  describe '#call' do
    context 'when invalid request' do

      it 'raise an error' do
        #$$expect{ raise StandardError }.to raise_error(StandardError)
        #result = valid_request_obj.call.result	
        expect{ invalid_request_obj.call }.to raise_error#(InvalidToken::InvalidToken)
	#xpect{ invalid_request_obj.call }.to raise_error(NotReader::NotReader)
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
