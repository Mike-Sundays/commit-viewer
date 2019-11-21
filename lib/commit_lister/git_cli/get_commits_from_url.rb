require 'tmpdir'
require 'directory_utils'
require 'result'
require 'will_paginate/array'
require_relative './git_wrapper'
require_relative './commit_constants'
require_relative '../url_helper'

module CommitListerCli
  class GetCommitsFromUrl

    DEFAULT_TIMEOUT_SECONDS = "30".freeze

    attr_reader :format, :page, :per_page

    def initialize(page, per_page)
      @format = CommitConstants::COMMIT_FORMAT
      @page = page
      @per_page = per_page
    end

    def run(url)
      project_path = nil

      begin
        raise GitWrapper::NoRepositoryError unless repo_exists?(url)

        project_path = download_repo_into_tmp_folder(url)

        DirectoryUtils.change_directory(project_path)

        log = get_array_of_commits

        paginated_log = paginate_result(log)

        Result.success(paginated_log)
      rescue StandardError => e
        Result.failure(e.message, true)
      ensure
        cleanup(project_path)
      end
    end

    private

    def repo_exists?(url)
      url_without_extension = UrlHelper.url_without_extension(url)
      GitWrapper::Commands.repo_exists?(url_without_extension)
    end

    def download_repo_into_tmp_folder(url)
      project_name = parse_project_name(url)
      tmp_dir = DirectoryUtils.create_temporary_directory

      project_path = File.join(tmp_dir, project_name)

      raise GitWrapper::GitCloneError unless cloned_repo?(project_path, url) &&
          DirectoryUtils.directory_exists?(project_path)

      project_path
    end

    def parse_project_name(url)
      UrlHelper.parse_project_name(url)
    end

    def cloned_repo?(dir, url)
      GitWrapper::Commands.clone_repo(url, DEFAULT_TIMEOUT_SECONDS, dir)
    end

    def get_array_of_commits
      commits = GitWrapper::Commands.get_commits(format_for_git)
      commits.split("\n")
    end

    def format_for_git
      correspondence = CommitConstants::FORMAT_CORRESPONDENCE
      format.map { |parameter| correspondence[parameter] }
          .join(CommitConstants::FORMAT_PARAMETERS_SEPARATOR)
    end

    def paginate_result(log)
      log.paginate(:page => page, :per_page => per_page)
    end

    def cleanup(dir)
      2.times { DirectoryUtils.change_directory("..") }
      DirectoryUtils.remove_directory(dir)
    end
  end
end
