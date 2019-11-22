# To add a new parameter to the log output,
# add it to the output format. You will then
# have to add a correspondence for each one of
# the sources, depending on the data structure it returns

# For the correspondence with the git log format parameters
# check the git documentation online

# For correspondence with the github v3 api response, see
# that api's documentation
class Constants
  OUTPUT_FORMAT = [:hash, :message, :author, :date].freeze

  GIT_CLI_FORMAT_CORRESPONDENCE = {
      :hash => "%H",
      :message => "%s",
      :author => "%an",
      :date => "%ad"
  }
  FORMAT_PARAMETERS_SEPARATOR = "|"

  API_RESPONSE_CORRESPONDENCE = {
      :hash => ["sha"],
      :author => ["commit", "author", "name"],
      :message => ["commit", "message"],
      :date => ["commit", "author", "date"]
  }

  DEFAULT_TIMEOUT_SECONDS = "30".freeze
end