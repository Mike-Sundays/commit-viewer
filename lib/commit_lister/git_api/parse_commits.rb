require 'date'
module CommitListerApi
  class ParseCommits
    attr_reader :log

    def initialize(log)
      @log = JSON.parse(log)
    end

    def run
      commits = []

      log.each do |element|
        commits << parse_commit(element)
      end

      commits
    end

    private

    def parse_commit(element)
      commit = extract_parameters(element)
      commit[:date] = parse_date_to_datetime(commit)
      commit
    end

    def extract_parameters(element)
      commit = {}
      commit[:hash] = element["sha"]
      commit[:author] = element["commit"]["author"]["name"]
      commit[:message] = element["commit"]["message"]
      commit[:date] = element["commit"]["author"]["date"]
      commit
    end

    def parse_date_to_datetime(commit)
      DateTime.parse(commit[:date])
    end
  end

end
