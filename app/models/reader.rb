class Reader < ApplicationRecord
  validates :rid, :uniqueness => true, :presence => true
  belongs_to :user, :optional => true
  has_many   :clients, dependent: :destroy
end
