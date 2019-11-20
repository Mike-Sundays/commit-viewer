# To add a new parameter to the log output,
# simply add it to these two constants.
# For the correspondence with the git % parameters
# check the git documentation online
class CommitConstants
  COMMIT_FORMAT = [:hash, :message, :author, :date].freeze
  FORMAT_CORRESPONDENCE = {
      :hash => "%H",
      :message => "%s",
      :author => "%an",
      :date => "%ad",
      :email => "%ae"
  }
  FORMAT_PARAMETERS_SEPARATOR = ","
end