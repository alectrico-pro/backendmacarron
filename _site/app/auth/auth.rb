#Encuentra el user que corresponde al reader
class Auth
  prepend SimpleCommand

  def initialize(params = {})
    @params = params
  end

  def call
    reader
  end

  private

  attr_reader :params

  def reader
    Reader.find_by( :rid => params[ :rid ] )    
  end


end
