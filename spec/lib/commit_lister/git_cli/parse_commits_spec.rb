require './lib/commit_lister/git_cli/parse_commits'

RSpec.describe CommitListerCli::ParseCommits do
  before :all do
    @valid_log = [
        '0e94cd1,add readme,mike-sundays,Tue Nov 12 12:21:11 2019 +0000',
        '744669,remove comment,mike-sundays,Mon Nov 11 21:03:17 2019 +0000'
    ]
  end

  it "should return a list of commits for valid input" do
    result = CommitListerCli::ParseCommits.new.run(@valid_log)
    first_commit = result.first

    expect(result).to be_instance_of(Array)
    expect(first_commit).to be_instance_of(Hash)
    expect(first_commit.keys).to include(:hash, :message, :author, :date)
    expect(first_commit[:date]).to be_instance_of(DateTime)
  end

  it "should return an empty list for no commits" do
    result = CommitListerCli::ParseCommits.new.run([])
    expect(result).to be_instance_of(Array)
    expect(result.size).to eql(0)
  end
end