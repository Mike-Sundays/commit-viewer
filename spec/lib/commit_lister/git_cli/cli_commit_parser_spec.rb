require './lib/commit_lister/git_cli/cli_commit_parser'

RSpec.describe CommitLister::CliCommitParser do
  before :all do
     @line = '0e94cd1,add readme,mike-sundays,Tue Nov 12 12:21:11 2019 +0000'
  end

  it "should return a list of commits for valid input" do
    result = CommitLister::CliCommitParser.new.run(@line)

    expect(result).to be_instance_of(Hash)
    expect(result.keys).to include(:hash, :message, :author, :date)
    expect(result[:date]).to be_instance_of(DateTime)
  end

  it "should return an empty list for no commits" do
    result = CommitLister::CliCommitParser.new.run("")
    expect(result).to be_instance_of(Hash)
    expect(result.keys.size).to eql(0)
  end
end