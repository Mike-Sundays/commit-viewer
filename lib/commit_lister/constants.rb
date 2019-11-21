# To add a new parameter to the log output,
# simply add it to these two constants.
# For the correspondence with the git % parameters
# check the git documentation online
class Constants
  COMMIT_FORMAT_TO_OUTPUT = [:hash, :message, :author, :date].freeze

  GIT_CLI_FORMAT_CORRESPONDENCE = {
      :hash => "%H",
      :message => "%s",
      :author => "%an",
      :date => "%ad"
  }
  FORMAT_PARAMETERS_SEPARATOR = ","

  API_RESPONSE_CORRESPONDENCE = {
      :hash => ["sha"],
      :author => ["commit", "author", "name"],
      :message => ["commit", "message"],
      :date => ["commit", "author", "date"]
  }
end