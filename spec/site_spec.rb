require_relative '../lib/makefolio'
require 'fileutils'
require 'RDiscount'
require 'erb'
require 'ostruct'

describe Makefolio::Site do
  before(:each) do
    @site = Makefolio::Site.new('./spec/_src')
  end

  describe "when created" do
    it "should have a path" do
      @site.path.to_s.should == './spec/_src'
    end

    it "should have a project path" do
      @site.project_path.to_s.should == './spec/_src/projects'
    end

    it "should have a template path" do
      @site.template_path.to_s.should == './spec/_src/templates'
    end

    it "should have a collection of projects" do
      names = @site.projects.collect { |p| p.name }
      names.should match_array([ 'one', 'two', 'three'])
    end
  end

  describe "when generating" do
    before(:each) do
      FileUtils.rm_rf('./spec/dist/')
      @site.generate
    end

    it "should create an html file for each project" do
      dist = Pathname.new('./spec/dist')
      files = dist.children.select { |c| c.file? }.collect { |c| c.relative_path_from(dist).to_s }
      files.should match_array([ 'one.html', 'two.html', 'three.html' ])
    end

    after(:all) do
      FileUtils.rm_rf('./spec/dist/')
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

    it "should have a desc property with the contents of <name>.md converted to HTML" do
      desc = RDiscount.new(IO.read('./spec/_src/projects/one/one.md')).to_html
      @project.desc.should == desc
    end
  end

  describe "when generated" do
    before(:each) do
      FileUtils.rm_rf('./spec/dist/')
      @site.generate
    end

    it "should have an html file containing the layout and description" do
      file_contents = IO.read('./spec/dist/one.html')

      binding = ErbBinding.new({ :content => @project.desc }).get_binding
      html = @site.erb_template.result(binding)

      file_contents.should == html
    end

    after(:all) do
      FileUtils.rm_rf('./spec/dist/')
    end
  end
end