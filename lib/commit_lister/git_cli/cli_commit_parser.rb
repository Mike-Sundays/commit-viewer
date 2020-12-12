require 'date'
require_relative '../constants'
require_relative '../parser_mixin'

module CommitLister
  class CliCommitParser
    include ParserMixin

    def extract_parameter(parameter, element)
      split_line = element.split(Constants::FORMAT_PARAMETERS_SEPARATOR)
      index = Constants::OUTPUT_FORMAT.find_index(parameter)
      split_line[index]
    end
  end
end
