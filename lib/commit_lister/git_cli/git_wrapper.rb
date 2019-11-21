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

    def self.get_commits(format)
      command = "git log --oneline --format='#{format}'"
      `#{command}`
    end

    def self.repo_exists?(url)
      response = HTTParty.get(url)
      response.code == 200 ? true : false
    end
  end
end