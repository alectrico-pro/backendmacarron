class Client < ApplicationRecord
  validates :clientId, :uniqueness => true, :presence => true
  belongs_to :reader
end
