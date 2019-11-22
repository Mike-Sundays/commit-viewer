require './lib/commit_lister/lister'
require './lib/commit_lister/git_api/api_commit_parser'
require './lib/commit_lister/git_api/api_commit_getter'
require './lib/commit_lister/git_cli/cli_commit_parser'
require './lib/commit_lister/git_cli/cli_commit_getter'

RSpec.describe CommitLister::Lister do
  before :all do
    @page = 1
    @per_page = 10
    @api_parser = CommitLister::ApiCommitParser.new
    @api_getter = CommitLister::ApiCommitGetter.new(@page, @per_page)
    @cli_parser = CommitLister::CliCommitParser.new
    @cli_getter = CommitLister::CliCommitGetter.new(@page, @per_page)
  end

  it "should return the same paginated list from both calls" do
    # This test will fail when the code does to many requests ,
    # due to the github throttler. It will demand authentication.
    url = "https://github.com/Mike-Sundays/simple-notes-react.git"

    api_result = CommitLister::Lister.new(url, @api_parser, @api_getter).run
    cli_result = CommitLister::Lister.new(url, @cli_parser, @cli_getter).run

    compare_results(api_result, cli_result)
  end

  it "should return a failure if url is invalid" do
    api_result = CommitLister::Lister.new("", @api_parser, @api_getter).run
    cli_result = CommitLister::Lister.new("", @cli_parser, @cli_getter).run

    compare_results(api_result, cli_result)
  end

  it "should return a failure if repo does not exist" do
    url = "https://github.com/Mike-Sundays/iehgsie.git"
    api_result = CommitLister::Lister.new(url, @api_parser, @api_getter).run
    cli_result = CommitLister::Lister.new(url, @cli_parser, @cli_getter).run

    compare_results(api_result, cli_result)
  end

  def compare_results(api_result, cli_result)
    expect(api_result.successful).to eql(cli_result.successful)
    expect(api_result.data).to eql(cli_result.data)
    expect(api_result.valid_input).to eql(cli_result.valid_input)
    expect(api_result.error).to eql(cli_result.error)
  end
end