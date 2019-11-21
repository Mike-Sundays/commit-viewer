module ParserMixin
  def run(element)
    commit = {}
    unless element.empty?
      commit = extract_parameters(element, commit)
      commit[:date] = DateTime.parse(commit[:date])
    end
    commit
  end

  private

  def extract_parameters(element, commit)
    Constants::OUTPUT_FORMAT.map do |parameter|
      commit[parameter] = extract_parameter(parameter, element)
    end
    commit
  end
end