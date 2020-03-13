require 'rails_helper'

RSpec.describe Todo, type: :model do
  #Association test
  #
  #ensure Todo Model has a 1:m relationship with the Item model
  it { should have_many(:items).dependent(:destroy)}

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }
    
#  pending "add some examples to (or delete) #{__FILE__}"
end
