module Makefolio
  class Project
    attr_accessor :name, :site, :desc, :path, :template

    def initialize(name, site)
      @name = name
      @site = site
      @path = @site.project_path.join @name
      @desc = read_desc
      @template = read_template
    end

    def read_desc
      desc_path = @path.join "#{@name}.md"
      desc_path.exist? ? RDiscount.new(IO.read(desc_path)).to_html : nil
    end

    def read_template
      template = @site.template_path.join "_project.html.erb"
      template.exist? ? IO.read(template) : nil
    end
  end
end
