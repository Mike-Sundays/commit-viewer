require 'date'

module CommitLister
  class ApiCommitParser
    def run(element)
      commit = extract_parameters(element)
      commit[:date] = parse_date_to_datetime(commit)
      commit
    end

    private

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
