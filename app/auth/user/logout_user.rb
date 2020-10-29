class LogoutUser
  prepend SimpleCommand
  include Linea

  def initialize(email, password,rid)
    @email = email
    @password = password
    @rid = rid
  end

  def call
    begin
      if user.id
	JsonWebToken.encode(user_id: user.id) 
      end
    rescue
      return
    end
  end

  private

  attr_accessor :email, :password, :rid

  def user
    user = User.find_by_rid(rid)
    linea.info "user es #{user.inspect}" if user
    linea.info "User será borrado"
    user.destroy if user
    user = User.find_by_rid(rid)
    linea.info "User se ha vuelto a buscar es: #{user.inspect}"

#    return user if user#&& user.authenticate(password)

 #   errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
