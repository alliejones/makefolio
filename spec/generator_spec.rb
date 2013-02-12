require_relative '../lib/makefolio'

describe Makefolio::Generator do
  before(:each) do
    @gen = Makefolio::Generator.new('./spec/_src/')
  end

  it "should list the project directories" do
    @gen.get_projects.should match_array([ 'one', 'two', 'three'])
  end
end