class Auth
  prepend SimpleCommand
  include NotAuthTokenPresent

  def initialize(params = {})
    @params = params
  end

  def call
    user
#    reader
  end

  private

  attr_reader :params

  def user
    reader = Reader.find_by( :rid => params[ :rid ] )    
  # cliente = Client.find_by(:clientID => @params[:clientId])
   #@user = cliente.reader.user
    @user ||= reader.user if reader
    @user || errors.add(:token, 'Token Inválido') && nil

  end


end
