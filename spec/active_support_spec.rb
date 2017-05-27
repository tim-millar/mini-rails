require 'spec_helper'

require 'active_support'
require 'active_record'

describe ActiveSupport do
  let!(:autoload_paths) {
    ActiveSupport::Dependencies.autoload_paths=(Dir["#{__dir__}/muffin_blog/app/*"])
  }

  describe '.search_for_file' do
    let(:file) { ActiveSupport::Dependencies.search_for_file('application_controller') }

    it 'returns the full path to the file' do
      expect(file).to eql("#{__dir__}/muffin_blog/app/controllers/application_controller.rb")
    end

    context 'when the file does not exist' do
      let(:file) { ActiveSupport::Dependencies.search_for_file('unknown') }

      it 'returns nil' do
        expect(file).to be_nil
      end
    end
  end

  describe '#underscore' do
    it 'converts camel case to underscore' do
      expect(:ApplicationController.to_s.underscore).to eql('application_controller')
    end
  end

  describe '#const_missing' do
    it 'autoloads files when a class constant is evaluated' do
      expect(Post).to eql(Post)
    end
  end
end
