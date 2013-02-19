module Makefolio
  class Project
    attr_accessor :name, :site, :desc, :path, :template, :front_matter

    def initialize(name, site)
      @name = name
      @site = site
      @path = @site.project_path.join @name

      read_content

      @template = read_template
    end

    def tpl_data
      @front_matter['desc'] = @desc
      if !@front_matter.has_key? 'title' or @front_matter['title'].empty?
        @front_matter['title'] = @name
      end

      @front_matter
    end

    def content_path
      @path.join "#{@name}.md"
    end

    def read_content
      if content_path.exist?
        content = IO.read(content_path)
      else
        content = ''
      end

      @front_matter = Helpers.parse_front_matter(content)

      md_desc = Helpers.strip_front_matter(content)
      @desc = RDiscount.new(md_desc).to_html
    end

    def read_template
      template = @site.template_path.join "_project.html.erb"
      template.exist? ? IO.read(template) : nil
    end
  end
end
