require_relative '../lib/makefolio'

require 'fileutils'
require 'rspec-html-matchers'

describe Makefolio::Project do
  let(:site) { Makefolio::Site.new './spec/_src/' }
  let(:project) { Makefolio::Project.new('one', site) }

  describe "with front matter" do
    it "should have a front_matter property with a hash of the data" do
      project.front_matter.should == { 'title' => 'Project One', 'template' => 'project' }
    end

    it "should have a desc property with the contents of <name>.md converted to HTML" do
      project = Makefolio::Project.new('one', site)
      project.desc.should have_tag 'p', :text => 'Test paragraph'
      project.desc.should have_tag 'li', :text => 'where'
    end

    it "should return front matter data and description in tpl_data" do
      project.tpl_data.keys.should include('title', 'template', 'desc')
      project.tpl_data['title'].should == 'Project One'
      project.tpl_data['template'].should == 'project'
      project.tpl_data['desc'].should match(/^<p>Test paragraph/)
    end
  end

  describe "without front matter" do
    let(:project) { Makefolio::Project.new('three', site) }

    it "should have a front_matter property set to an empty hash" do
      project.front_matter.should == {}
    end

    it "should have a desc property with the contents of <name>.md converted to HTML" do
      project = Makefolio::Project.new('three', site)
      project.desc.should have_tag 'p', :text => 'Test paragraph'
      project.desc.should have_tag 'li', :text => 'A moment after all four'
    end

    it "should return description and default title in tpl_data" do
      project.tpl_data.keys.should include('title', 'desc')
      project.tpl_data['title'].should == 'three'
      project.tpl_data['desc'].should match(/^<p>Test paragraph/)
    end
  end

  describe "when created" do
    it "should have a correctly set path" do
      project = Makefolio::Project.new('one', site)
      project.path.to_s.should == './spec/_src/projects/one'
    end

    describe "with a missing content file" do
      before do
        Pathname.new('./spec/_src/projects/one/one.md').rename('./spec/_src/projects/one/wrong.md')
        project = Makefolio::Project.new('one', site)
      end

      it "should set the description and front matter correctly" do
        project.desc.strip.should == ''
        project.front_matter.should == {}
      end

      after do
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
