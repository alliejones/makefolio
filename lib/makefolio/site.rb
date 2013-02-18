module Makefolio
  class Site
    attr_accessor :path, :project_path, :template_path, :projects

    def initialize(path)
      @path = Pathname.new(path)

      @project_dir = 'projects'
      @template_dir = 'templates'
      @dist_dir = 'dist'

      create_projects
    end

    def project_path
      @path.join @project_dir
    end

    def template_path
      @path.join @template_dir
    end

    def dist_path
      @path.parent.join @dist_dir
    end

    def generate
      Dir.mkdir dist_path unless dist_path.exist?

      generate_index
      generate_project_pages
    end

    private
    def get_layout(name = 'layout')
      IO.read template_path.join("#{name}.html.erb")
    end

    def get_template(name)
      IO.read template_path.join("_#{name}.html.erb")
    end

    def create_projects
      @projects = []

      project_path.children.select { |c| c.directory? }.each do |c|
        project_name = c.relative_path_from(project_path).to_s
        project = Project.new(project_name, self)

        @projects << project
      end
    end

    def generate_index
      save_html_file 'index', get_template('index'), { projects: @projects }, get_layout
    end

    def generate_project_pages
      @projects.each { |p| generate_project_page p }
    end

    def generate_project_page(project)
      data = { name: project.name, desc: project.desc }

      save_html_file project.name, project.template, data, get_layout
    end

    def save_html_file(filename, template, data, layout)
      page = Template.new(template, data, layout)

      filepath = dist_path.join "#{filename}.html"
      File.open(filepath, 'w') { |file| file.write page.to_html }
    end
  end
end