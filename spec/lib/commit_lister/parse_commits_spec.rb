require './lib/commit_lister/parse_commits'

RSpec.describe CommitLister::ParseCommits do
  before :all do
    @valid_log = [
        '0e94cd1,add readme,mike-sundays,Tue Nov 12 12:21:11 2019 +0000',
        '744669,remove comment,mike-sundays,Mon Nov 11 21:03:17 2019 +0000'
    ]
  end

  it "should return a list of commits for valid input" do
    result = CommitLister::ParseCommits.new(
        @valid_log, ',', [:hash, :message, :author, :date]
    ).run
    first_commit = result.first

    expect(result).to be_instance_of(Array)
    expect(first_commit).to be_instance_of(Hash)
    expect(first_commit.keys).to include(:hash, :message, :author, :date)
    expect(first_commit[:date]).to be_instance_of(DateTime)
  end

  it "should return an empty list for no commits" do
    result = CommitLister::ParseCommits.new(
        [], ",", [:hash, :message, :author, :date]
    ).run
    expect(result).to be_instance_of(Array)
    expect(result.size).to eql(0)
  end
end