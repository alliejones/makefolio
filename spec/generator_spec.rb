require_relative '../lib/makefolio'

describe Makefolio::Site do
  before(:each) do
    @gen = Makefolio::Site.new('./spec/_src/')
  end

  describe "when created" do
    it "should have a collection of projects" do
      names = @gen.projects.collect { |p| p.name }
      names.should match_array([ 'one', 'two', 'three'])
    end
  end
end