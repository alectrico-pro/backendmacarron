class LogoutUser
  prepend SimpleCommand

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
    user.destroy if user
#    return user if user#&& user.authenticate(password)

 #   errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
