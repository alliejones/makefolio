require 'yaml'

module Makefolio
  class Helpers
    # selects the text between '---' lines
    FRONT_MATTER_PATTERN = /[\n]*[-]{3}[\n]([\s\S]*)[\n]*[-]{3}[\n]/

    def self.parse_front_matter(content)
      match = content.match(@@front_matter_pattern)

      if match.nil?
        { }
      else
        YAML.load(match[0])
      end
    end

    def self.strip_front_matter(content)
      content.gsub(FRONT_MATTER_PATTERN, '').strip
    end

    def self.large_image_filename(filename)
      File.basename(filename, '.*') + '-lg' + File.extname(filename)
    end
  end
end
