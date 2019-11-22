require './lib/commit_lister/git_api/api_commit_parser'
require 'json'

RSpec.describe CommitLister::ApiCommitParser do
  before :all do
    path = "./spec/lib/commit_lister/git_api/github_api_example_response.json"
    @commit = JSON.load(File.new(path))
  end

  it "should return a list of commits for valid input" do
    result = CommitLister::ApiCommitParser.new.run(@commit)

    expect(result).to be_instance_of(Hash)
    expect(result.keys).to include(:hash, :message, :author, :date)
    expect(result[:date]).to be_instance_of(DateTime)
  end

  it "should return an empty hash for no commits" do
    result = CommitLister::ApiCommitParser.new.run({})
    expect(result).to eql({})
  end
end