require 'tmpdir'
require 'directory_utils'
require 'result'
require 'will_paginate/array'
require_relative './git_cli_wrapper'
require_relative '../constants'
require_relative '../url_helper'

module CommitLister
  class CliCommitGetter

    attr_reader :page, :per_page

    def initialize(page, per_page)
      @page = page
      @per_page = per_page
    end

    def run(url)
      project_path = nil

      begin
        project_path = download_repo_into_tmp_folder(url)
        DirectoryUtils.change_directory(project_path)

        log = extract_local_log
        paginated_log = paginate_result(log)

        Result.success(paginated_log)
      rescue StandardError => e
        Result.failure(e.message, true)
      ensure
        cleanup(project_path)
      end
    end

    private

    def download_repo_into_tmp_folder(url)
      project_name = parse_project_name(url)
      project_path = DirectoryUtils.temporary_directory_for_project(project_name)

      raise GitWrapper::GitCloneError unless
          cloned_repo?(project_path, url) &&
          DirectoryUtils.directory_exists?(project_path)

      project_path
    end

    def parse_project_name(url)
      UrlHelper.parse_project_name(url)
    end

    def cloned_repo?(dir, url)
      GitWrapper::Commands.clone_repo(
          url, Constants::DEFAULT_TIMEOUT_SECONDS, dir
      )
    end

    def extract_local_log
      GitWrapper::Commands.get_commits.split("\n")
    end

    def paginate_result(log)
      log.paginate(:page => page, :per_page => per_page)
    end

    def cleanup(dir)
      DirectoryUtils.cleanup_temp_dir(dir)
    end
  end
end
