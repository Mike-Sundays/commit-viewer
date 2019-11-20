require 'tmpdir'
require 'date'
require_relative '../commit_constants'

module CommitLister

  # parses pretty printed git logs, with a commit in each line
  class ParseCommits
    attr_reader :log, :separator, :format

    def initialize(log, separator, format)
      @log = log
      @separator = separator
      @format = format
    end

    def run
      log.map { |line| parse_commit(line) }
    end

    private

    def parse_commit(line)
      commit = fill_in_commit_info(line)
      commit[:date] = parse_date_to_datetime(commit)
      commit
    end

    def fill_in_commit_info(line)
      commit = {}
      split_line = line.split(separator)

      format.map do |parameter|
        index = index_of_param(parameter)
        commit[parameter] = split_line[index]
      end
      commit
    end

    def parse_date_to_datetime(commit)
      DateTime.parse(commit[:date])
    end

    def index_of_param(parameter)
      format.find_index(parameter)
    end
  end

end
