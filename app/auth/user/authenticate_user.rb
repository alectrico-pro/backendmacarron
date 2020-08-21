class AuthenticateUser
  prepend SimpleCommand

  def initialize(rid)
    @rid = rid
  end

  def call
    JsonWebToken.encode(reader_id: reader.id) if reader
  end


  public 
  attr_accessor :email

  private
  attr_accessor :rid, :reader

  def reader
    reader = Reader.find_by_rid(rid)
    user = reader.user if reader
    @email = user.email if user and  user.valid?
    return user if user #and user.valid?#&& user.authenticate(password)
    errors.add :user_authentication, 'invalid credentials'
    nil
  end

end
