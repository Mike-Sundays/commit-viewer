require 'tmpdir'
require 'date'
require_relative './git_log_cli_format'

module CommitLister

  # parses pretty printed git logs, with a commit in each line
  class CliCommitParser
    attr_reader :separator, :format

    def initialize
      @separator = GitLogCliFormat::FORMAT_PARAMETERS_SEPARATOR
      @format = GitLogCliFormat::COMMIT_FORMAT_TO_OUTPUT
    end

    def run(element)
      commit = {}
      unless element.empty?
        commit = fill_in_commit_info(element, commit)
        commit[:date] = parse_date_to_datetime(commit)
      end
      commit
    end

    private

    def fill_in_commit_info(line, commit)
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
