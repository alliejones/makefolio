require_relative '../lib/makefolio'

require 'fileutils'
require 'rspec-html-matchers'

describe Makefolio::Project do
  let(:site) { Makefolio::Site.new './spec/_src/' }
  let(:project) { Makefolio::Project.new('one', site) }

  describe "when created" do
    it "should have a correctly set path" do
      project = Makefolio::Project.new('one', site)
      project.path.to_s.should == './spec/_src/projects/one'
    end

    it "should have a desc property with the contents of <name>.md converted to HTML" do
      project = Makefolio::Project.new('one', site)
      desc = RDiscount.new(IO.read './spec/_src/projects/one/one.md').to_html
      project.desc.should == desc
    end

    describe "with a missing description" do
      before do
        Pathname.new('./spec/_src/projects/one/one.md').rename('./spec/_src/projects/one/wrong.md')
        project = Makefolio::Project.new('one', site)
      end

      it "should set the description to nil" do
        project.desc.should be_nil
      end

      after(:all) do
        Pathname.new('./spec/_src/projects/one/wrong.md').rename('./spec/_src/projects/one/one.md')
      end
    end
  end

  describe "when generated" do
    before do
      FileUtils.rm_rf './spec/dist/'
      site.generate
    end

    it "should have an html file containing the layout and description" do
      project = IO.read './spec/dist/one.html'

      project.should have_tag 'head'
      project.should have_tag 'p', :text => 'Test paragraph'
    end

    after(:all) do
      # FileUtils.rm_rf './spec/dist/'
    end
  end
end
