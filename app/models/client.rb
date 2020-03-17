class Client < ApplicationRecord
  #El cliente está conectado al dispositivo
  validates :clientId, :uniqueness => true, :presence => true
  belongs_to :reader
end
