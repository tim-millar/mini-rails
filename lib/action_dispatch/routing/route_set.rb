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

      private

      def mapper
        Mapper.new(self)
      end

      class Route < Struct.new(:method, :path, :controller, :action, :name)
        def match?(request)
          request.request_method == method && request.path_info == path
        end
      end
    end
  end
end
