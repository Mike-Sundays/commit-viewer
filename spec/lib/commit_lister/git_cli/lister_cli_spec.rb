require './lib/commit_lister/lister'
require './lib/commit_lister/git_cli/cli_commit_parser'
require './lib/commit_lister/git_cli/cli_commit_getter'

RSpec.describe CommitLister::Lister do
  before :all do
    @page = 1
    @per_page = 10
    @parser = CommitLister::CliCommitParser.new
    @getter = CommitLister::CliCommitGetter.new(@page, @per_page)
  end

  it "should return paginated list of commits" do
    url = "https://github.com/Mike-Sundays/simple-notes-react.git"

    result = CommitLister::Lister.new(url, @parser, @getter).run
    first_commit = result.data.first

    expect(result.successful).to eql(true)
    expect(result.data).to be_instance_of(Array)
    expect(first_commit).to be_instance_of(Hash)
    expect(first_commit.keys).to include(:hash, :message, :author, :date)
    expect(first_commit[:date]).to be_instance_of(DateTime)
    expect(result.data.size).to eql(@per_page)
  end

  it "should return a failure if url is invalid" do
    result = CommitLister::Lister.new("", @parser, @getter).run

    expect(result.successful).to eql(false)
    expect(result.error).to be
  end

  it "should return a failure if repo does not exist" do
    result = CommitLister::Lister.new(
        "https://github.com/Mike-Sundays/iehgsie.git",
        @parser, @getter
    ).run

    expect(result.successful).to eql(false)
    expect(result.error).to be
  end
end