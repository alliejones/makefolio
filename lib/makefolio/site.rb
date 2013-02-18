module Makefolio
  class Site
    attr_accessor :path, :project_path, :template_path, :projects

    def initialize(path)
      @path = Pathname.new(path)

      @project_dir = 'projects'
      @template_dir = 'templates'
      @dist_dir = 'dist'

      @layout = IO.read template_path.join('layout.html.erb')

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
    def create_projects
      @projects = []

      project_path.children.select { |c| c.directory? }.each do |c|
        project_name = c.relative_path_from(project_path).to_s
        project = Project.new(project_name, self)

        @projects << project
      end
    end

    def generate_index
      index_tpl = IO.read template_path.join('_index.html.erb')
      layout = IO.read template_path.join('layout.html.erb')

      page = Template.new(index_tpl, { projects: @projects }, layout)

      file = File.open(dist_path.join("index.html"), 'w') do |file|
        file.write page.to_html
      end
    end

    def generate_project_pages
      @projects.each { |p| generate_project_page p }
    end

    def generate_project_page(project)
      html = Template.new(project.template, { name: project.name, desc: project.desc }, @layout).to_html
      save_html_file project.name, html
    end

    def save_html_file(name, contents)
      filepath = dist_path.join "#{name}.html"
      File.open(filepath, 'w') do |file|
        file.write contents
      end
    end
  end
end