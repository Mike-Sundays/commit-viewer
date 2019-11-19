require 'tmpdir'
require 'date'
require_relative './commit_constants'

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
      commit = {}
      split_line = line.split(separator)

      format.map do |parameter|
        index = index_of_param(parameter)
        commit[parameter] = split_line[index]
      end

      commit[:date] = DateTime.parse(commit[:date])
      commit
    end

    def index_of_param(parameter)
      format.find_index(parameter)
    end
  end

end
