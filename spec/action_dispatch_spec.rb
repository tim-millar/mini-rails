require 'spec_helper'

module ActionDispatch
  module Routing
    describe RouteSet do
      describe '#add_route' do
        subject(:route) { routes.add_route('GET', '/posts', 'posts', 'index') }

        let(:routes) { RouteSet.new }

        it 'stores the controller' do
          expect(route.controller).to eql('posts')
        end

        it 'stores the controller action' do
          expect(route.action).to eql('index')
        end
      end

      describe '#find_route' do
        subject(:route) { routes.find_route(request) }

        let(:routes) { RouteSet.new }
        let!(:index) { routes.add_route('GET', '/posts', 'posts', 'index') }
        let!(:create) { routes.add_route('POST', '/posts', 'posts', 'create') }

        let(:request) {
          double(
            'Rack::Request',
            request_method: 'POST',
            path_info: '/posts',
          )
        }

        it { is_expected.to eql(create) }
      end

      describe '#draw' do
        subject(:route) { routes.find_route(request) }

        let(:routes) { RouteSet.new }

        let!(:posts) {
          routes.draw do
            get '/hello', to: 'hello#index'
            root to: 'posts#index'
            resources :posts
          end
        }

        let(:request) {
          double(
            'Rack::Request',
            request_method: 'GET',
            path_info: '/posts/new',
          )
        }

        it 'routes to correct controller action' do
          expect(route.action).to eql('new')
        end

        it 'creates the correct path name' do
          expect(route.name).to eql('new_post')
        end
      end

      describe '#call' do
        subject(:routes) { Rails.application.routes }

        let(:request) { Rack::MockRequest.new(routes) }

        it 'routes requests to the root' do
          expect(request.get('/')).to be_ok
        end

        it 'routes requests to the correct action' do
          expect(request.get('/posts/new')).to be_ok
        end

        it 'forwards query string params' do
          expect(request.get('/posts/show?id=1')).to be_ok
        end

        it '404s for incorrect requests' do
          expect(request.post('/')).to be_not_found
        end
      end

      describe 'middleware stack' do
        subject(:app) { Rails.application }

        let(:request) { Rack::MockRequest.new(app) }

        it 'routes requests to the root' do
          expect(request.get('/')).to be_ok
        end

        it 'routes requests to the correct action' do
          expect(request.get('/posts/new')).to be_ok
        end

        it 'forwards query string params' do
          expect(request.get('/posts/show?id=1')).to be_ok
        end

        it '404s for incorrect requests' do
          expect(request.post('/')).to be_not_found
        end

        it 'finds favicon.ico' do
          expect(request.get('/favicon.ico')).to be_ok
        end

        it 'finds application.js' do
          expect(request.get('/assets/application.js')).to be_ok
        end

        it 'finds application.css' do
          expect(request.get('/assets/application.css')).to be_ok
        end
      end
    end
  end
end
