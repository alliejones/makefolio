require 'makefolio/version'
require 'erb'
require 'RDiscount'
require 'ostruct'

module Makefolio
  class Site
    attr_accessor :path, :project_path, :template_path, :projects

    def initialize(path)
      @path = Pathname.new(path)

      @project_dir = 'projects'
      @template_dir = 'templates'
      @dist_dir = 'dist'

      @layout_file = 'layout.html.erb'

      create_projects
    end

    def project_path
      @path.join(@project_dir)
    end

    def template_path
      @path.join(@template_dir)
    end

    def dist_path
      @path.parent.join(@dist_dir)
    end

    def erb_template
      layout = IO.read(template_path.join(@layout_file))
      erb = ERB.new(layout)
    end

    def generate
      Dir.mkdir(dist_path) unless dist_path.exist?

      generate_project_index
      generate_project_pages
    end

    private
      def create_projects
        @projects = []

        project_path.children.select { |c| c.directory? }.each do |c|
          project_name = c.relative_path_from(project_path).to_s
          project = Project.new(project_name, self)

          @projects << project
        end
      end

      def generate_project_index
      end

      def generate_project_pages
        @projects.each { |p| generate_project_page(p) }
      end

      def generate_project_page(project)
        binding = ErbBinding.new({ :content => project.desc }).get_binding
        file = File.new(dist_path.join("#{project.name}.html"), 'w')
        file.write(erb_template.result(binding))
        file.close
      end
  end

  class Project
    attr_accessor :name, :site, :desc, :path

    def initialize(name, site)
      @name = name
      @site = site
      @path = @site.project_path.join(@name)
      @desc = read_desc
    end

    def read_desc
      RDiscount.new(IO.read(@path.join("#{@name}.md"))).to_html
    end
  end
end

class ErbBinding < OpenStruct
  def get_binding
    binding
  end
end