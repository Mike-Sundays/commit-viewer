require 'date'
require_relative '../constants'
require_relative '../parser_mixin'

module CommitLister
  class ApiCommitParser
    include ParserMixin

    def extract_parameter(parameter, element)
      keys_of_param = Constants::API_RESPONSE_CORRESPONDENCE[parameter]
      element.dig(*keys_of_param)
    end
  end

end
