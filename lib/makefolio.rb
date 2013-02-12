require "makefolio/version"

module Makefolio
  class Site
    attr_accessor :projects

    def initialize(path)
      @path = path
      @project_dir = 'projects'

      create_projects
    end

    private
      def create_projects
        @projects = []

        parent = Pathname.new(@path+@project_dir)
        parent.children.select { |c| c.directory? }.each do |c|
          project_name = c.relative_path_from(parent).to_s
          @projects.push Project.new(project_name)
        end
      end
  end

  class Project
    attr_accessor :name

    def initialize(name)
      @name = name
    end
  end
end
