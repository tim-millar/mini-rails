module ActionDispatch
  module Routing
    class Mapper
      def initialize(route_set)
        @route_set = route_set
      end

      def get(path, to:, as: nil)
        controller, action = to.split('#')
        @route_set.add_route('GET', path, controller, action, as)
      end

      def root(to:)
        get('/', to: to, as: 'root')
      end

      def resources(name)
        get("/#{name}", to: "#{name}#index", as: name)
        get("/#{name}/new", to: "#{name}#new", as: "new_#{name.to_s.singularize}")
        get("/#{name}/show", to: "#{name}#show", as: name.to_s.singularize)
      end
    end
  end
end
