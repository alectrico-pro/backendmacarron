class DestroyUser
  prepend SimpleCommand

  def initialize( rid)
    @rid = rid
  end

  def call
    reader
  end

  private

  attr_accessor :rid

  def reader
    reader = Reader.find_by(:rid => rid)
    reader.user.destroy if reader and reader.user
    return true
  end
end
