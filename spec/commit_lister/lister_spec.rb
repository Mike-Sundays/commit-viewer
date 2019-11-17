# these are integration tests that communicate directly with github
require './lib/commit_lister/lister'

describe CommitLister::Lister do
  before :all do
    @url = "https://github.com/Mike-Sundays/simple-notes-react.git"
  end

  it "should return a hash of commits" do
    result = CommitLister::Lister.new(@url).run
    first_commit = result[:data].first

    expect(result[:success]).to eql(true)
    expect(result[:data]).to be_instance_of(Array)
    expect(first_commit).to be_instance_of(Hash)
    expect(first_commit.keys).to match_array([:hash, :message, :author, :date])
    expect(first_commit[:date]).to be_instance_of(DateTime)
  end

  it "should return a failure if url is invalid" do
    result = CommitLister::Lister.new("").run

    expect(result[:success]).to eql(false)
    expect(result[:error]).to be
  end

  it "should return a failure if repo does not exist" do
    result = CommitLister::Lister.new("https://github.com/iehgsie.git").run

    expect(result[:success]).to eql(false)
    expect(result[:error]).to be
  end
end