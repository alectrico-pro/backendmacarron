class Macarron < Macaroon 
  extend Linea

  def self.deserialize( macarron_serializado )
    self.from_binary( macarron_serializado )
  end

end
