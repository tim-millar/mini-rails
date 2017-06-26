module ActionDispatch
  module Routing
    class RouteSet
      def initialize
        @routes = []
      end

      def add_route(*args)
        Route.new(*args).tap do |route|
          @routes << route
        end
      end

      def find_route(request)
        @routes.detect { |route| route.match?(request) }
      end

      def draw(&block)
        mapper.instance_eval(&block)
      end

      def call(env)
        request = Rack::Request.new(env)

        if route = find_route(request)
          route.dispatch(request)
        else
          [404, { 'Content-Type' => 'text/plain' }, ['Not found']]
        end
      end

      private

      def mapper
        Mapper.new(self)
      end

      class Route < Struct.new(:method, :path, :controller, :action, :name)
        def match?(request)
          request.request_method == method && request.path_info == path
        end

        def dispatch(request)
          controller = controller_class.new
          controller.request = request
          controller.response = Rack::Response.new
          controller.process(action)
          controller.response.finish
        end

        def controller_class
          "#{controller.classify}Controller".constantize
        end
      end
    end
  end
end
