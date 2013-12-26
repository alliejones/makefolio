module Makefolio
  
  class Site
    attr_accessor :path, :project_path, :template_path, :projects
    
    def initialize(path)
      @path = Pathname.new(path)
      
      @project_dir = 'projects'
      @template_dir = 'templates'
      @dist_dir = 'dist'
      @resources_dir = 'resources'
      
      create_projects
    end
    
    def project_path
      @path.join @project_dir
    end
    
    def template_path
      @path.join @template_dir
    end
    
    def resources_path
      @path.join @resources_dir
    end
    
    def dist_path
      @path.parent.join @dist_dir
    end
    
    def generate
      Dir.mkdir dist_path unless dist_path.exist?
      
      generate_index
      generate_project_pages
      generate_images
      generate_resource_directory
    end
    
    def initialize_projects
      @projects.each do |project|
        project.create_image_metadata
        project.create_description_file
      end
    end
    
    private
    def get_layout(name = 'layout')
      IO.read template_path.join("#{name}.html.erb")
    end
    
    def get_template(name)
      IO.read template_path.join("_#{name}.html.erb")
    end
    
    def create_projects
      @projects = project_path.children.select(&:directory?).map do |c|
        project_name = c.relative_path_from(project_path).to_s
        Project.new(project_name, self)
      end
      
      @projects.sort! do |p1, p2|
        p1_sort = p1.front_matter['sort'] || Float::INFINITY
        p2_sort = p2.front_matter['sort'] || Float::INFINITY
        p1_sort<=>p2_sort
      end
    end
    
    def generate_index
      projects = @projects.collect { |p| p.tpl_data }
      save_html_file 'index', get_template('index'), { 'projects' => projects }, get_layout
    end
    
    def generate_project_pages
      @projects.each { |p| generate_project_page p }
    end
    
    def generate_project_page(project)
      save_html_file project.name, project.template, project.tpl_data, get_layout
    end
    
    def generate_images
      @projects.each { |p| p.generate_images }
    end
    
    def generate_resource_directory
      FileUtils::cp_r(resources_path.to_s + '/.', dist_path)
    end
    
    def save_html_file(filename, template, data, layout)
      page = Template.new(template, data, layout)
      
      filepath = dist_path.join "#{filename}.html"
      File.open(filepath, 'w') { |file| file.write page.to_html }
    end
  end
end