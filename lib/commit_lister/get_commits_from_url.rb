require 'tmpdir'
require 'net/http'
require 'directory_utils'

module CommitLister
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

  class GetCommitsFromUrl

    DEFAULT_TIMEOUT_SECONDS = "30".freeze

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def run
      project_name = parse_project_name(url)
      tmp_dir = nil

      begin
        raise NoRepositoryError unless repo_exists?

        tmp_dir = DirectoryUtils.create_temporary_directory
        DirectoryUtils.change_directory(tmp_dir)

        raise GitCloneError unless clone_repo(url)

        wait_until_directory_is_cloned(project_name)
        DirectoryUtils.change_directory(project_name)

        log = get_commits.split("\n")

        {:success => true, :data => log, :error => nil}
      rescue StandardError => e
        {:success => false, :data => nil, :error => e.message}
      ensure
        cleanup(tmp_dir)
      end
    end

    private

    def repo_exists?
      url_without_extension = url.split(".git")[0]
      response = Net::HTTP.get_response(URI(url_without_extension))
      response.code == "200" ? true : false
    end

    def parse_project_name(url)
      url.split('/')[-1].split('.')[0]
    end

    def clone_repo(url)
      # see https://stackoverflow.com/questions/1936633
      # for justification of this syntax
      system("timeout", "#{DEFAULT_TIMEOUT_SECONDS}", "git", "clone", "#{url}")
    end

    def wait_until_directory_is_cloned(directory)
      # protecting against the clone command returning success before
      # having cloned the repo completely
      until File.directory?(directory)
        sleep(1)
      end
    end

    def get_commits
      command = "git log --oneline --format='%H,%s,%an,%ad'"
      `#{command}`
    end

    def cleanup(dir)
      DirectoryUtils.change_directory("/tmp")
      DirectoryUtils.remove_directory(dir)
    end
  end
end
