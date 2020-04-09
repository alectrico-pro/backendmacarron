class CreateToken
  prepend SimpleCommand

  def initialize(rid,clientId)
    @rid = rid
    @clientId = clientId
  end

  def call
    token = AccessKey.new.get
#    token = JsonWebToken.encode(reader: reader.as_json(:include => :user,:root => true)) if reader
  end

  private

  def reader
    reader = Reader.find_or_create_by(:rid => @rid)
    cliente = reader.clients.find_or_create_by(:clientId => @clientId)
    return reader if reader.save(:context => :create_token) and cliente.save(:context => :create_token)
    errors.add :user_authentication,  reader.errors
    nil
    puts reader.inspect
  end

end
