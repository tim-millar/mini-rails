require 'spec_helper'

class TestController < ActionController::Base
  def index
    @var = 'var value'
  end
end

module ActionView
  describe Template do
    describe '#render_template' do
      subject(:template) {
        Template.new('<p>Hello</p>', 'test_render_template')
      }

      let(:context) { Base.new }

      it 'renders the HTML' do
        expect(template.render(context)).to eql('<p>Hello</p>')
      end

      context 'with variables' do
        subject(:template) {
          Template.new('<p><%= @var %></p>', 'test_render_with_vars')
        }

        let(:context) { Base.new(var: 'var value')}

        it 'renders the HTML' do
          expect(template.render(context)).to eql('<p>var value</p>')
        end
      end

      context 'with yield' do
        subject(:template) {
          Template.new('<p><%= yield %></p>', 'test_render_with_yield')
        }

        let(:context) { Base.new }

        it 'renders the HTML' do
          expect(template.render(context) { 'yielded content' }).
            to eql('<p>yielded content</p>')
        end
      end

     context 'with helper' do
        subject(:template) {
          Template.new(
            "<%= link_to 'title', '/url' %>",
            'test_render_with_helper'
          )
        }

        let(:context) { Base.new }

        it 'renders the HTML' do
          expect(template.render(context)).to eql("<a href=\"/url\">title</a>")
        end
     end

      context 'find template' do
        let(:file) { "#{__dir__}/muffin_blog/app/views/posts/index.html.erb" }
        let(:template_one) { Template.find(file) }
        let(:template_two) { Template.find(file) }

        it 'caches templates' do
          expect(template_one).to eql(template_two)
        end
      end
    end

    describe 'view assigns' do
      let(:controller) { TestController.new }

      it 'assigns instance variables in the controller' do
        controller.index

        expect(controller.view_assigns).to eql({ 'var' => 'var value' })
      end
    end

    describe '#render' do
      let(:request) { Rack::MockRequest.new(Rails.application) }
      let(:response) { request.get('/posts/show?id=1') }

      it 'populates the response with the view' do
        expect(response.body).to include('<h1>Blueberry Muffins</h1>')
      end

      it 'renders the view within the application layout' do
        expect(response.body).to include('<html>')
      end
    end
  end
end
