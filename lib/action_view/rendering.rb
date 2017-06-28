module ActionView
  module Rendering
    def render(action)
      path = template_path(action)
      content = Template.find(path).render(context)
      body = Template.find(layout_path).render(context) do
        content
      end

      response.body = [body]
    end

    def view_assigns
      instance_variables.inject({}) do |assigns, name|
        assigns.tap do |assigns|
          assigns[name[1..-1]] = instance_variable_get(name)
        end
      end
    end

    private

    def template_path(action)
      "#{Rails.root}/app/views/#{controller_name}/#{action}.html.erb"
    end

    def context
      Base.new(view_assigns)
    end

    def layout_path
      "#{Rails.root}/app/views/layouts/application.html.erb"
    end

    def controller_name
      self.class.name.chomp('Controller').underscore
    end
  end
end
