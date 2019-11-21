require_relative '../validation/validate_url'
require_relative './parse_commits'
require_relative './get_commits_from_url'
require 'result'

module CommitListerApi
  class Lister
    attr_reader :url

    DEFAULT_PAGE = 1.freeze
    DEFAULT_PER_PAGE = 10.freeze

    attr_reader :url, :page, :per_page

    def initialize(url, page = DEFAULT_PAGE, per_page = DEFAULT_PER_PAGE)
      @url = url
      @page = page || DEFAULT_PAGE
      @per_page = per_page || DEFAULT_PER_PAGE
    end

    def run

      begin
        validation = valid_url?
        if validation[:valid]
          list = process_commits_from_url
          Result.success(list)
        else
          Result.failure(validation[:error], false)
        end
      rescue StandardError => e
        Result.failure(e.message, true)
      end
    end

    private

    def valid_url?
      CommitListerCli::ValidateUrl.new(url).validate
    end

    def process_commits_from_url
      response = request_github_api
      parse_into_list(response.data)
    end

    def request_github_api
      CommitListerApi::GetCommitsFromUrl.new(url, page, per_page).run
    end

    def parse_into_list(response)
      CommitListerApi::ParseCommits.new(response).run
    end
  end
end
