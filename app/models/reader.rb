class Reader < ApplicationRecord
  validates :rid, :uniqueness => true, :presence => true
  belongs_to :user, :optional => true
  has_many   :clients, dependent: :destroy

  def logout
    update(:logged_in => false)
  end

  def login
    update(:logged_in => true)
  end

end
