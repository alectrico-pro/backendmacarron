class Reader < ApplicationRecord
  validates :rid, :uniqueness => true, :presence => true
  belongs_to :user, :optional => true
  has_many   :clients, dependent: :destroy

  def logout
    linea.info "logout"
    update(:logged_in => false)
    linea.info "logged_in es #{logged_in}"
  end

  def login
    linea.info "login"
    update(:logged_in => true)
    linea.info "logged_in es #{logged_in}"
  end

end
