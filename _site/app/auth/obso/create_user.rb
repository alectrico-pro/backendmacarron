class CreateUser
  prepend SimpleCommand

  def initialize(email, password, password_confirmation, rid, clientId)
    @email    = email
    @password = password
    @rid      = rid
    @clientId = clientId
    @password_confirmation = password_confirmation
  end

  def call
    #Atencíón, actualemnte uso reader_id enlugar de user_id, debido a que no puedo traspasar el token al usuairo pero sí puedo traspasarloa un reader id de AMP, porque AMP ofrece rid garantizado.
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :email, :password, :password_confirmation, :rid, :clientId

  def user #Crea o actuliza el usuario existente, dado el rid de identificación
    user = User.find_by(:email => email)
    if user
      user.update_attributes(:email => email, :password => password, :password_confirmation => password_confirmation, :clientId => clientId, :rid => rid )
    else
      user = User.create(:name => "nombre",:rid => rid, :email => email, :password => password, :password_confirmation => password_confirmation,:clientId => clientId ) 
    end

#   return user if user.save
    return user if user.save && user.authenticate(password)
    errors.add :user_authentication, user.errors
    nil
  end
end
