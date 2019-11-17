require_relative './validate_url'
require_relative './get_commits_from_url'
require_relative './parse_commits'

module CommitLister
  class Lister

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def run
      begin
        validation = valid_url?(url)
        if validation[:valid]
          log = get_commits_from_url
          list = parse_into_list(log[:data], ',')
          {:success=> true, :data => list, :error => nil}
        else
          {:success=> false, :data => nil, :error => validation[:error]}
        end
      rescue StandardError => e
        {:success=> false, :data => nil, :error => e.message}
      end
    end

    private

    def get_commits_from_url
      CommitLister::GetCommitsFromUrl.new(url).run
    end

    def parse_into_list(log, separator)
      CommitLister::ParseCommits.new(log, separator).run
    end

    def valid_url?(url)
      CommitLister::ValidateUrl.new(url).validate
    end
  end
end