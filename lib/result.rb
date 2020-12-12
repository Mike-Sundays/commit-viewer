class Result

  attr_reader :successful, :data, :error, :valid_input

  def initialize(successful, data, error, valid_input)
    @successful = successful
    @data = data
    @error = error
    @valid_input = valid_input
  end

  def self.success(data)
    self.new(true, data, nil, true)
  end

  def self.failure(error, valid_input)
    self.new(false, nil, error, valid_input)
  end
end