require 'tmpdir'
require 'date'

module CommitLister

  # parses pretty printed git logs, with a commit in each line
  class ParseCommits
    attr_reader :log, :separator

    def initialize(log, separator)
      @log = log
      @separator = separator
    end

    def run
      commit_hash_list = []

      log.each do |line|
        commit_hash_list << parse_commit(line)
      end
      commit_hash_list
    end

    private

    def parse_commit(line)
      commit = {}
      split_line = line.split(separator)
      commit[:hash] = split_line[0]
      commit[:message] = split_line[1]
      commit[:author] = split_line[2]
      commit[:date] = DateTime.parse(split_line[3])
      commit
    end
  end

end
