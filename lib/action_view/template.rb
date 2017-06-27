require 'erb'

module ActionView
  class Template
    CACHE = Hash.new do |cache, file|
      cache[file] = Template.new(File.read(file), file)
    end

    def initialize(source, name)
      @source = source
      @name = name
      @compiled = false
    end

    def self.find(file)
      CACHE[file]
    end

    def render(context, &block)
      compile
      context.send(method_name, &block)
    end

    def method_name
      @name.gsub(/[^\w]/, '_')
    end

    def compile
      CompiledTemplates.module_eval <<-CODE
        def #{method_name}
          #{code}
        end
      CODE

      @compiled = true
    end

    private

    def code
      ERB.new(@source).src
    end
  end
end
