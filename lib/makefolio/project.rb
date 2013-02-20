require 'pry'

module Makefolio
  class Project
    attr_accessor :name, :site, :desc, :images, :path, :template, :front_matter

    def initialize(name, site)
      @name = name
      @site = site
      @path = @site.project_path.join @name

      read_content
      @images = read_image_metadata
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

    def image_metadata_path
      @path.join 'images.yml'
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

    def create_image_metadata
      unless image_metadata_path.exist?
        image_fields = { 'path' => nil, 'alt' => nil }
        image_paths = read_image_paths

        image_data = []

        image_paths.each do |path|
          data = image_fields.clone
          data['path'] = path
          image_data << data
        end

        File.open(image_metadata_path, 'w') { |file| file.write image_data.to_yaml }
      end
    end

    def read_image_paths
      image_glob = @path.join('img', '*.{jpg,png,gif}')
      images = Pathname::glob(image_glob)
      images.map! do |image_pathname|
        image_pathname.relative_path_from(@path).to_s
      end
    end

    def read_image_metadata
      if image_metadata_path.exist?
        YAML.load(IO.read image_metadata_path)
      else
        []
      end
    end

    def read_template
      template = @site.template_path.join "_project.html.erb"
      template.exist? ? IO.read(template) : nil
    end
  end
end
