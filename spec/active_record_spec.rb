require 'spec_helper'

require 'active_record'

require 'muffin_blog/app/models/application_record'
require 'muffin_blog/app/models/post'

module ActiveRecord
  describe Base do
    let!(:establish_connection) {
      Post.establish_connection(
        database: "#{__dir__}/muffin_blog/db/development.sqlite3"
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
        expect(post).to be_an_instance_of(Post)
      end
      
      it 'has the correct id' do
        expect(post.id).to eql(1)
      end

      it 'has the correct title' do
        expect(post.title).to eql('Blueberry Muffins')
      end
    end

    describe '.execute' do
      let(:rows) { Post.connection.execute('SELECT * FROM posts') }
      let(:column_names) { [:id, :title, :body, :created_at, :updated_at] }
      let(:row) { rows.first }

      it 'returns an array of rows from the posts table' do
        expect(rows).to be_an_instance_of(Array)
      end

      it 'represents rows as hashes' do
        expect(row).to be_an_instance_of(Hash)
      end

      it 'returns all the table column names' do
        expect(row.keys).to eql(column_names)
      end
    end
  end
end
