# these are tests that communicate directly with github
require './lib/commit_lister/lister'

RSpec.describe CommitLister::Lister do
  before :all do
    @url = "https://github.com/Mike-Sundays/simple-notes-react.git"
  end

  it "should return a default paginated list of commits" do
    result = CommitLister::Lister.new(@url).run
    first_commit = result.data.first

    expect(result.successful).to eql(true)
    expect(result.data).to be_instance_of(Array)
    expect(first_commit).to be_instance_of(Hash)
    expect(first_commit.keys).to include(:hash, :message, :author, :date)
    expect(first_commit[:date]).to be_instance_of(DateTime)
    expect(result.data.size).to eql(10)
  end

  it "should return list of commits with 2 per page" do
    result = CommitLister::Lister.new(@url, 1, 2).run
    first_commit = result.data.first

    expect(result.successful).to eql(true)
    expect(result.data).to be_instance_of(Array)
    expect(first_commit).to be_instance_of(Hash)
    expect(first_commit.keys).to include(:hash, :message, :author, :date)
    expect(first_commit[:date]).to be_instance_of(DateTime)
    expect(result.data.size).to eql(2)
  end

  it "should return a failure if url is invalid" do
    result = CommitLister::Lister.new("").run

    expect(result.successful).to eql(false)
    expect(result.error).to be
  end

  it "should return a failure if repo does not exist" do
    result = CommitLister::Lister.new("https://github.com/Mike-Sundays/iehgsie.git").run

    expect(result.successful).to eql(false)
    expect(result.error).to be
  end

  it "should return a failure for injected bash command" do
    result = CommitLister::Lister.new(
        "https://github.com/Mike-Sundays/simple-notes-react.git && touch badfile.txt"
    ).run

    expect(result.successful).to eql(false)
    expect(result.error).to be
  end
end