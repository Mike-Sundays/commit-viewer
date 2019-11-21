# To add a new parameter to the log output,
# simply add it to these two constants.
# For the correspondence with the git % parameters
# check the git documentation online
class GitLogCliFormat
  COMMIT_FORMAT_TO_OUTPUT = [:hash, :message, :author, :date].freeze
  GIT_CLI_FORMAT_CORRESPONDENCE = {
      :hash => "%H",
      :message => "%s",
      :author => "%an",
      :date => "%ad",
      :email => "%ae"
  }
  FORMAT_PARAMETERS_SEPARATOR = ","

  def self.format_string
    format = COMMIT_FORMAT_TO_OUTPUT.clone
    correspondence = GIT_CLI_FORMAT_CORRESPONDENCE
    format.map { |parameter| correspondence[parameter] }
        .join(FORMAT_PARAMETERS_SEPARATOR)
  end
end