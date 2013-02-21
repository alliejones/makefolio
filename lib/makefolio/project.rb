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
      @front_matter['images'] = @images

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

    def images_dist_path
      @site.dist_path.join('img', @name)
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
        image_fields = { 'filename' => nil, 'alt' => nil }
        image_filenames = read_image_filenames

        image_data = image_filenames.map do |filename|
          data.merge('filename' => filename)
        end

        File.open(image_metadata_path, 'w') { |file| file.write image_data.to_yaml }
      end
    end

    def read_image_paths
      image_glob = @path.join('img', '*.{jpg,png,gif}')

      # ignore large versions of images
      Pathname::glob(image_glob).reject! do |pathname|
        pathname.basename.to_s.match(/.*-lg\..*/)
      end
    end

    def read_image_filenames
      images = read_image_paths.map do |image_path|
        image_path.basename.to_s
      end
    end

    def read_image_metadata
      if image_metadata_path.exist?
        images = YAML.load(IO.read image_metadata_path)
        images.each do |image|
          path = images_dist_path.join(image['filename']).relative_path_from(@site.dist_path)
          image['path'] = path.to_s

          filename_large = Helpers::large_image_filename(image['filename'])
          image['filename_large'] = filename_large

          path_large = images_dist_path.join(filename_large).relative_path_from(@site.dist_path)
          image['path_large'] = path_large.to_s
        end
      else
        []
      end
    end

    def generate_images
      site_image_path = @site.dist_path.join 'img'
      unless site_image_path.exist?
        site_image_path.mkdir
      end

      FileUtils::copy_entry(@path.join('img'), images_dist_path)
    end

    def read_template
      template = @site.template_path.join "_project.html.erb"
      template.exist? ? IO.read(template) : nil
    end
  end
end
