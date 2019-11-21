require_relative './validation/validate_url'
require 'result'

module CommitLister
  class Lister

    attr_reader :url, :parser, :getter

    def initialize(url, parser, getter)
      @url = url
      @parser = parser
      @getter = getter
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

    def process_commits_from_url
      commits = []
      result = get_commits

      result.each do |element|
        commits << parse_commits(element)
      end

      commits
    end

    def valid_url?
      CommitListerCli::ValidateUrl.new(url).validate
    end

    def get_commits
      getter.run(url).data
    end

    def parse_commits(element)
      parser.run(element)
    end
  end
end