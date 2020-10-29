class LogoutReader
  prepend SimpleCommand
  include Linea
  
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
    linea.info "Reader #{@reader.inspect}"
    @reader
  end
end
