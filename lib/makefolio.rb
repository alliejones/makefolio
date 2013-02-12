require "makefolio/version"

module Makefolio
  class Generator
    def initialize(path)
      @path = path
      @project_dir = 'projects'
    end

    def get_projects
      parent = Pathname.new(@path+@project_dir)
      parent.children.select { |c| c.directory? }.collect { |c| c.relative_path_from(parent).to_s }
    end
  end

  class Project
  end
end
