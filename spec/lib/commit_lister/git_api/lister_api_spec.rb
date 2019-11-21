# these are tests that communicate directly with github
require './lib/commit_lister/lister'
require './lib/commit_lister/git_api/parse_commits'
require './lib/commit_lister/git_api/get_commits_from_url'

RSpec.describe CommitLister::Lister do
  before :all do
    @url = "https://github.com/Mike-Sundays/simple-notes-react.git"
    @page = 1
    @per_page = 10
    @parser = CommitListerApi::ParseCommits.new
    @getter = CommitListerApi::GetCommitsFromUrl.new(@page, @per_page)
  end

  it "should return a default paginated list of commits" do
    result = CommitLister::Lister.new(@url, @parser, @getter).run
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
        @parser,@getter
    ).run

    expect(result.successful).to eql(false)
    expect(result.error).to be
  end
end