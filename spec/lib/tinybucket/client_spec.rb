require 'spec_helper.rb'

RSpec.describe Tinybucket::Client do
  include ApiResponseMacros

  let(:client) { Tinybucket::Client.new({}) }

  describe 'new' do
    let(:options) { {} }

    context 'without block' do
      subject { Tinybucket::Client.new(options) }
      it { expect(subject.config).to eq(options) }
    end

    context 'with block' do
      subject do
        Tinybucket::Client.new do |config|
          options.each_pair do |key, value|
            config.send("#{key}=", value)
          end
        end
      end
      it { expect(subject.config).to eq(options) }
    end
  end

  describe 'repos' do
    subject { client.repos }
    before { stub_apiresponse(:get, '/repositories') }
    it { expect(subject).to be_instance_of(Tinybucket::Models::Page) }
  end

  describe 'repo' do
    let(:repo_owner) { 'test_owner' }
    let(:repo_slug) { 'test_repo' }

    subject { client.repo(repo_owner, repo_slug) }

    it 'return RepoApi instance' do
      expect(subject).to be_instance_of(Tinybucket::Api::RepoApi)
      expect(subject.repo_owner).to eq(repo_owner)
      expect(subject.repo_slug).to eq(repo_slug)
    end
  end

  describe 'team' do
    let(:team) { 'test_team' }
    subject { client.team(team) }
    it { expect(subject).to be_instance_of(Tinybucket::Api::TeamApi) }
  end

  describe 'user' do
    let(:user) { 'test_owner' }
    subject { client.user(user) }
    it { expect(subject).to be_instance_of(Tinybucket::Api::UserApi) }
  end
end