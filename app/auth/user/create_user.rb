#Crea un user y devuelve un token de autorización, si el usuario fue exitosamente creado (o actualizad0)
#El corazón del token es el id del cliente.
class CreateUser
  prepend SimpleCommand

  def initialize(name, email, password, password_confirmation, rid, clientId)

    @name     = name
    @email    = email
    @password = password
    @rid      = rid #Id única de amp pages para controlar la lectura de publicidad.
    @clientId = clientId #Id única de dispositivo por cliente, dispositivo y browser (corresponde a amp_client_id)
    @password_confirmation = password_confirmation

  end

  def call
    #Atencíón, actualmente uso reader_id enlugar de user_id, debido a que no puedo traspasar el token al usuario pero sí puedo traspasarlo a un reader id de AMP, porque AMP ofrece rid garantizado.
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :email, :password, :password_confirmation, :rid, :clientId

  def user #Crea o actualiza el usuario existente, dado el rid de identificación

    user = User.find_by(:email => email)
    if user
      user.update_attributes(:name => name, email => email, :password => password, :password_confirmation => password_confirmation, :clientId => clientId, :rid => rid )
    else
      user = User.create(:name => name, :rid => rid, :email => email, :password => password, :password_confirmation => password_confirmation,:clientId => clientId ) 
    end

#   return user if user.save
    return user if user.save && user.authenticate(password)
    errors.add :user_authentication, user.errors
    nil
  end
end
