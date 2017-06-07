require 'spec_helper'

class TestController < ActionController::Base
  before_action :callback, only: [:show]
  after_action :callback_after, only: [:show]

  def index
    response << 'index'
  end

  def show
    response << 'show'
  end

  def redirect
    redirect_to '/'
  end

  private

  def callback
    response << 'callback'
  end

  def callback_after
    response << 'callback_after'
  end
end

describe ActionController do
  let(:controller) { TestController.new }
  let(:response) { [] }

  before do
    allow(controller).to receive(:response).and_return(response)
  end

  describe '#process' do
    subject { controller.process(:index) }

    it 'populates the response' do
      subject

      expect(controller.response).to eql(['index'])
    end
  end

  describe '.before_action' do
    subject { controller.process(:show) }

    it 'runs the relevant callback' do
      subject

      expect(controller.response).to eql(['callback', 'show', 'callback_after'])
    end
  end

  describe 'real controller' do
    let(:controller) { PostsController.new }
    let(:request) { double('Request', params: params) }
    let(:params) { { 'id' => 1 } }
    let(:post) { double('Post') }

    before do
      allow(controller).to receive(:request).and_return(request)
      allow(Post).to receive(:find).with(1).and_return(post)
    end

    it 'runs the callbacks on a real controller' do
      controller.process(:show)

      expect(controller.instance_variable_get(:@post)).to eql(post)
    end
  end

  describe 'redirect_to' do
    subject { controller.process(:redirect) }

    let(:controller) { TestController.new }
    let(:response) { double('Response') }

    before do
      allow(response).to receive(:status=).with(302).and_return(response)
      allow(response).to receive(:location=).with('/').and_return(response)
      allow(response).to receive(:body=).with(['You are being redirected']).
        and_return(response)
    end

    it 'redirects the user' do
      subject

      expect(controller.response).to have_received(:status=).with(302)
    end

    it 'redirects the user to the root url' do
      subject

      expect(controller.response).to have_received(:location=).with('/')
    end

    it 'informs the user that they are being redirected' do
      subject

      expect(controller.response).to have_received(:body=).
        with(['You are being redirected'])
    end
  end
end
