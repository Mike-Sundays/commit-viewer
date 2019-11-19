require_relative './validate_url'
require_relative './get_commits_from_url'
require_relative './parse_commits'
require_relative './commit_constants'
require 'will_paginate/array'
require 'result'

module CommitLister
  class Lister

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
        validation = valid_url?(url)
        if validation[:valid]
          result = get_commits_from_url
          paginated_log = paginate_log!(result.data)
          list = parse_into_list(paginated_log, ',')
          Result.success(list)
        else
          Result.failure(validation[:error], false)
        end
      rescue StandardError => e
        Result.failure(e.message, true)
      end
    end

    private

    def get_commits_from_url
      CommitLister::GetCommitsFromUrl.new(
          url, CommitConstants::COMMIT_FORMAT
      ).run
    end

    def paginate_log!(commit_array)
      commit_array.paginate(:page => page, :per_page => per_page)
    end

    def parse_into_list(log, separator)
      CommitLister::ParseCommits.new(
          log, separator, CommitConstants::COMMIT_FORMAT
      ).run
    end

    def valid_url?(url)
      CommitLister::ValidateUrl.new(url).validate
    end
  end
end