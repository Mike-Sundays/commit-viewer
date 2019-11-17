require 'tmpdir'
require 'date'

module CommitLister
  class ParseCommits
    attr_reader :log

    def initialize(log)
      @log = log
    end

    def run
      commit_list = []

      log.each_line do |line|
        commit_list << parse_commit(line)
      end
      commit_list
    end

    private

    def parse_commit(line)
      commit = {}
      split_line = line.split(',')
      commit[:hash] = split_line[0]
      commit[:message] = split_line[1]
      commit[:author] = split_line[2]
      commit[:date] = DateTime.parse(split_line[3])
      commit
    end
  end

end
