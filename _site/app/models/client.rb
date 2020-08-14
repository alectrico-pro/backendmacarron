class Client < ApplicationRecord
  #El cliente está conectado al dispositivo
  validates :clientId, :uniqueness => {:scope => :reader_id, :message => "El reader solo puede tener un cliente"}, :presence => true 
  belongs_to :reader
end
