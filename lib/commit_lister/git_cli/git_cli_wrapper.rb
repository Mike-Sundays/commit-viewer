require 'httparty'

module GitWrapper
  class GitCloneError < StandardError
    def message
      "Error in git clone command, exit status #{$?.exitstatus}"
    end
  end

  class NoRepositoryError < StandardError
    def message
      "The repository you provided does not exist"
    end
  end

  class Commands
    def self.clone_repo(url, timeout, dir)
      # see https://stackoverflow.com/questions/1936633
      # for justification of this syntax
      system("timeout", "#{timeout}", "git", "clone", "#{url}", dir)
    end

    def self.get_commits
      command = "git log --oneline --format='#{format_string}'"
      `#{command}`
    end

    private

    def self.format_string
      format = Constants::COMMIT_FORMAT_TO_OUTPUT.clone
      correspondence = Constants::GIT_CLI_FORMAT_CORRESPONDENCE
      format.map { |parameter| correspondence[parameter] }
          .join(Constants::FORMAT_PARAMETERS_SEPARATOR)
    end
  end
end