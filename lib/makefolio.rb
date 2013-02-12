require "makefolio/version"

module Makefolio
  class Site
    attr_accessor :path, :project_dir, :projects

    def initialize(path)
      @path = Pathname.new(path)
      @project_dir = 'projects'

      create_projects
    end

    private
      def create_projects
        @projects = []

        parent = @path.join @project_dir
        parent.children.select { |c| c.directory? }.each do |c|
          project_name = c.relative_path_from(@path.join(@project_dir)).to_s
          project = Project.new(project_name, self)

          @projects.push(project)
        end
      end
  end

  class Project
    attr_accessor :name, :site, :desc, :path

    def initialize(name, site)
      @site = site
      @name = name
      @path = @site.path.join(@site.project_dir, @name)
      @desc = IO.read(@path.join("#{@name}.md"))
    end
  end
end
