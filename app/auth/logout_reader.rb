class LogoutReader
  prepend SimpleCommand

  def initialize(rid)
    @rid = rid
  end

  def call
    reader
#   JsonWebToken.encode( reader: reader.as_json(:include => :user)) if reader
  end

  private

  attr_accessor :rid, :reader

  def reader
    linea.info "En reader de LogoutReader"
    @reader = Reader.find_by(:rid => rid)
    @reader.try :logout
    @reader
  end
end
