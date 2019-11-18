require 'tmpdir'
require 'fileutils'

module CommitLister
  class GitCloneError < StandardError
    def message
      "Error in git clone command, exit status #{$?.exitstatus}"
    end
  end

  class GetCommitsFromUrl

    DEFAULT_TIMEOUT_SECONDS = "60".freeze

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def run
      project_name = parse_project_name(url)
      tmp_dir = create_temporary_directory
      begin
        change_directory(tmp_dir)
        if clone_repo(url, DEFAULT_TIMEOUT_SECONDS)
          wait_until_directory_is_cloned(project_name)
          change_directory(project_name)
          log = get_commits
        else
          raise GitCloneError
        end

        {:success => true, :data => log, :error => nil}
      rescue StandardError => e
        {:success => false, :data => nil, :error => e.message}
      ensure
        remove_directory(tmp_dir)
      end
    end

    private

    def create_temporary_directory
      Dir.mktmpdir(nil, "#{Dir.pwd}/tmp/repos")
    end

    def change_directory(path)
      Dir.chdir(path)
    end

    def remove_directory(path)
      FileUtils.remove_entry path
    end

    def parse_project_name(url)
      url.split('/')[-1].split('.')[0]
    end

    def clone_repo(url, timeout_seconds)
      system("timeout #{timeout_seconds}s git clone #{url}")
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
  end
end
