require_relative '../lib/makefolio'

describe Makefolio::Site do
  before(:each) do
    @site = Makefolio::Site.new('./spec/_src/')
  end

  describe "when created" do
    it "should have a path" do
      @site.path.to_s.should == './spec/_src/'
    end

    it "should have a collection of projects" do
      names = @site.projects.collect { |p| p.name }
      names.should match_array([ 'one', 'two', 'three'])
    end
  end
end

describe Makefolio::Project do
  before(:each) do
    @site = Makefolio::Site.new('./spec/_src/')
    @project = Makefolio::Project.new('one', @site)
  end

  describe "when created" do
    it "should have a correctly set path" do
      @project.path.to_s.should == './spec/_src/projects/one'
    end

    it "should have a desc property with the contents of <name>.md" do
      desc = IO.read('./spec/_src/projects/one/one.md')
      @project.desc.should == desc
    end
  end
end