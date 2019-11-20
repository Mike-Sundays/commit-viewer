require 'tmpdir'
require 'directory_utils'
require_relative './git_wrapper'
require_relative './commit_constants'
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
      project_path = nil

      begin
        raise GitWrapper::NoRepositoryError unless repo_exists?

        project_path = download_repo_into_tmp_folder

        DirectoryUtils.change_directory(project_path)

        log = get_array_of_commits

        Result.success(log)
      rescue StandardError => e
        Result.failure(e.message, true)
      ensure
        cleanup(project_path)
      end
    end

    private

    def repo_exists?
      GitWrapper::Commands.repo_exists?(url)
    end

    def download_repo_into_tmp_folder
      project_name = parse_project_name
      tmp_dir = DirectoryUtils.create_temporary_directory

      project_path = File.join(tmp_dir, project_name)

      raise GitWrapper::GitCloneError unless
          cloned_repo?(project_path) &&
          DirectoryUtils.directory_exists?(project_path)

      project_path
    end

    def parse_project_name
      url.split('/')[-1].split('.')[0]
    end

    def cloned_repo?(dir)
      GitWrapper::Commands.clone_repo(url, DEFAULT_TIMEOUT_SECONDS, dir)
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
