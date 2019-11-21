require 'date'
require_relative '../constants'

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

      Constants::COMMIT_FORMAT_TO_OUTPUT.map do |parameter|
        commit[parameter] = extract_parameter(parameter)
      end

      commit
    end

    def extract_parameter(parameter)
      keys_of_param = Constants::API_RESPONSE_CORRESPONDENCE[parameter]
      element.dig(*keys_of_param)
    end

    def parse_date_to_datetime(commit)
      DateTime.parse(commit[:date])
    end
  end

end
