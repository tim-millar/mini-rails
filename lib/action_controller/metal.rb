module ActionController
  class Metal
    attr_accessor :request, :response
    attr_accessor :status, :location, :body

    def process(action)
      send(action)
    end

    def params
      request.params.symbolize_keys
    end
  end
end
