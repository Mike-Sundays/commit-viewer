require 'tmpdir'

module CommitLister
  class GitCloneError < StandardError
  end

  class GetCommitsFromUrl
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def run
      begin
        log = nil
        project_name = parse_project_name(url)
        Dir.mktmpdir { |dir|
          change_directory(dir)
          if clone_repo(url)
            change_directory(project_name)
            log = get_commits
          else
            raise GitCloneError, "Error in git clone command, exit status #{$?.exitstatus}"
          end
        }
        {:success=> true, :data => log, :error => nil}
      rescue StandardError => e
        {:success=> false, :data => nil, :error => e.message}
      end
    end

    private

    def parse_project_name(url)
      url.split('/')[-1].split('.')[0]
    end

    def change_directory(path)
      Dir.chdir(path)
    end

    def clone_repo(url)
      system("git clone #{url}")
    end

    def get_commits
      command = "git log --oneline --format='%H,%s,%an,%ad'"
      `#{command}`
    end
  end
end
