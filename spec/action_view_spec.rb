require 'spec_helper'

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
  end
end
