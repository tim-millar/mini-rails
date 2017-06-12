# This file is used by Rack-based servers to start the application.

# require ::File.expand_path('../config/environment', __FILE__)
# run Rails.application

class Logger
  def initialize(app)
    @app = app
  end

  def call(env)
    request = env['REQUEST_METHOD']
    path = env['PATH_INFO']
    puts "#{request} #{path}"
    @app.call(env)
  end
end

class MiniSinatra
  class Route < Struct.new(:method, :path, :block)
    def match?(env)
      env['REQUEST_METHOD'] == method && env['PATH_INFO'] == path
    end
  end

  def initialize
    @routes = []
  end

  def add_route(method, path, &block)
    @routes << Route.new(method, path, block)
  end

  def call(env)
    if route = @routes.detect { |route| route.match?(env) }
      body = route.block.call
      [
        200,
        { 'Content-Type' => 'text/plain' },
        [body],
      ]
    else
      [
        404,
        { 'Content-Type' => 'text/plain' },
        ['File not found.'],
      ]
    end
  end

  def self.application
    @application ||= MiniSinatra.new
  end
end

def get(path, &block)
  MiniSinatra.application.add_route 'GET', path, &block
end

get '/hello' do
  'hello from the hello uri'
end
get '/goodbye' do
  'goodbye from all of us here'
end

use Logger
run MiniSinatra.application
