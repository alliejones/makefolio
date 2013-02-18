module Makefolio
  class Template
    attr_accessor :template, :data, :layout

    # content and layout should be a template in the form of a string
    # data should be a hash
    def initialize(content_template, data, layout=nil)
      @content_template = erb_template(content_template)
      layout ||= '<%= content %>'
      @layout = erb_template(layout)
      @data = data
    end

    def erb_template(template)
      erb = ERB.new(template)
    end

    def erb_binding(data)
      ErbBinding.new(data).get_binding
    end

    def to_html
      content = @content_template.result erb_binding(@data)
      @layout.result erb_binding(content: content)
    end


    class ErbBinding < OpenStruct
      def get_binding
        binding
      end
    end

  end
end