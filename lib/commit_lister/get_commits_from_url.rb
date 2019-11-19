require 'tmpdir'
require 'net/http'
require 'directory_utils'
require_relative './git_wrapper'
require 'result'

module CommitLister
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
        raise GitWrapper::NoRepositoryError unless repo_exists?

        tmp_dir = setup_temp_folder
        DirectoryUtils.change_directory(tmp_dir)

        raise GitWrapper::GitCloneError unless clone_repo(url)

        wait_until_directory_is_cloned(project_name)
        DirectoryUtils.change_directory(project_name)

        log = get_array_of_commits

        Result.success(log)
      rescue StandardError => e
        Result.failure(e.message, true)
      ensure
        cleanup(tmp_dir)
      end
    end

    private

    def repo_exists?
      GitWrapper::Commands.repo_exists?(url)
    end

    def parse_project_name(url)
      url.split('/')[-1].split('.')[0]
    end

    def setup_temp_folder
      DirectoryUtils.create_temporary_directory
    end

    def clone_repo(url)
      GitWrapper::Commands.clone_repo(url, DEFAULT_TIMEOUT_SECONDS)
    end

    def wait_until_directory_is_cloned(directory)
      # protecting against the clone command returning success before
      # having cloned the repo completely
      sleep(1) until DirectoryUtils.directory_exists?(directory)
    end

    def get_array_of_commits
      GitWrapper::Commands.get_list_of_commits_oneliner.split("\n")
    end

    def cleanup(dir)
      DirectoryUtils.change_directory("/tmp")
      DirectoryUtils.remove_directory(dir)
    end
  end
end
