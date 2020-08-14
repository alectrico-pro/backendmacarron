RSpec.describe "Catching errors" do
  it "raise Error" do
    expect{raise "oops"}.to raise_error("oops" )
  end
end

