require 'spec_helper'

require 'active_record'

require 'muffin_blog/app/models/application_record'
require 'muffin_blog/app/models/post'

module ActiveRecord
  describe Base do
    let!(:establish_connection) {
      Post.establish_connection(
        database: "#{__dir__}/muffin_blog/db/development.sqlite"
      )
    }

    describe '.initialize' do
      let(:post) { Post.new(id: 1, title: 'My first post') }

      it 'stores its id attribute' do
        expect(post.id).to eql(1)
      end

      it 'stores its title attribute' do
        expect(post.title).to eql('My first post')
      end
    end

    describe '.find' do
      let(:post) { Post.find(1) }

      it 'returns an instance of the Post class' do
        expect(post.class).to eql(Post)
      end
      
      it 'has the correct id' do
        expect(post.id).to eql(1)
      end

      it 'has the correct title' do
        expect(post.title).to eql('My first post')
      end
    end

    describe '.execute' do
      # rows = Post.connection.execute('SELECT * FROM posts')
      # p rows
    end
  end
end
