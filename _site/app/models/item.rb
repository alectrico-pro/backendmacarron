#Item de una lista To Do
class Item < ApplicationRecord
  belongs_to :todo
  validates :name, :presence => true
end
