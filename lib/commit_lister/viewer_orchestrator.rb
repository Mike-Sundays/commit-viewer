require_relative './lister'
require_relative './git_api/get_commits_from_url'
require_relative './git_api/api_commit_parser'
require_relative './git_cli/get_commits_from_url'
require_relative './git_cli/cli_commit_parser'

module CommitLister
  class ViewerOrchestrator

    DEFAULT_PAGE = 1.freeze
    DEFAULT_PER_PAGE = 10.freeze

    attr_reader :url, :page, :per_page

    def initialize(url, page = DEFAULT_PAGE, per_page = DEFAULT_PER_PAGE)
      @url = url
      @page = page || DEFAULT_PAGE
      @per_page = per_page || DEFAULT_PER_PAGE
    end

    def run
      result = commits_from_github_api
      unless result.successful
        result = commits_from_github_cli
      end
      result
    end

    private

    def commits_from_github_api
      CommitLister::Lister.new(
          url, parser_api, getter_api
      ).run
    end

    def commits_from_github_cli
      CommitLister::Lister.new(
          url, parser_cli, getter_cli
      ).run
    end

    def getter_api
      CommitListerApi::GetCommitsFromUrl.new(
          page, per_page
      )
    end

    def parser_api
      CommitLister::ApiCommitParser.new
    end

    def getter_cli
      CommitListerCli::GetCommitsFromUrl.new(
          page, per_page
      )
    end

    def parser_cli
      CommitLister::CliCommitParser.new
    end
  end
end