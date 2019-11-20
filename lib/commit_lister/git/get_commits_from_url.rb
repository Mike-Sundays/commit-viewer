require 'tmpdir'
require 'net/http'
require 'directory_utils'
require_relative './git_wrapper'
require_relative '../commit_constants'
require 'result'

module CommitLister
  class GetCommitsFromUrl

    DEFAULT_TIMEOUT_SECONDS = "30".freeze

    attr_reader :url, :format

    def initialize(url, format)
      @url = url
      @format = format
    end

    def run
      tmp_dir = nil

      begin
        raise GitWrapper::NoRepositoryError unless repo_exists?

        tmp_dir = download_repo_into_tmp_folder
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

    def download_repo_into_tmp_folder
      project_name = parse_project_name
      tmp_dir = DirectoryUtils.create_temporary_directory

      DirectoryUtils.change_directory(tmp_dir)

      raise GitWrapper::GitCloneError unless clone_repo

      wait_until_directory_is_cloned(project_name)
      DirectoryUtils.change_directory(project_name)

      tmp_dir
    end

    def parse_project_name
      url.split('/')[-1].split('.')[0]
    end

    def clone_repo
      GitWrapper::Commands.clone_repo(url, DEFAULT_TIMEOUT_SECONDS)
    end

    def wait_until_directory_is_cloned(directory)
      # protecting against the clone command returning success before
      # having cloned the repo completely
      sleep(1) until DirectoryUtils.directory_exists?(directory)
    end

    def get_array_of_commits
      commits = GitWrapper::Commands.get_commits(format_for_git)
      commits.split("\n")
    end

    def format_for_git
      correspondence = CommitConstants::FORMAT_CORRESPONDENCE
      format.map{|parameter| correspondence[parameter] }
          .join(CommitConstants::FORMAT_PARAMETERS_SEPARATOR)
    end

    def cleanup(dir)
      2.times { DirectoryUtils.change_directory("..") }
      DirectoryUtils.remove_directory(dir)
    end
  end
end
