require 'result'
require 'httparty'
require_relative '../url_helper'

module CommitListerApi
  class GetCommitsFromUrl

    DEFAULT_TIMEOUT_SECONDS = "30".freeze
    OWNER_PLACEHOLDER = ":owner"
    REPO_PLACEHOLDER = ":repo"
    URL_API = "https://api.github.com/repos/#{OWNER_PLACEHOLDER}/#{REPO_PLACEHOLDER}/commits"

    attr_reader :url, :page, :per_page

    def initialize(url,page, per_page)
      @url = url
      @page = page
      @per_page = per_page
    end

    def run
      begin
        owner, project = get_owner, parse_project_name
        url = build_url(owner, project)
        response = request_github_api(url, project)

        Result.success(response)
      rescue StandardError => e
        Result.failure(e.message, true)
      end
    end

    private

    def get_owner
      UrlHelper.get_owner(url)
    end

    def parse_project_name
      UrlHelper.parse_project_name(url)
    end

    def build_url(owner, project)
      url = URL_API.clone
      url.gsub!(OWNER_PLACEHOLDER, owner).
          gsub!(REPO_PLACEHOLDER, project)
    end

    def request_github_api(url, project)
      headers = get_headers(project)
      response = HTTParty.get(
          url, headers: headers,
          query: query_string,
          timeout: DEFAULT_TIMEOUT_SECONDS
      )
      response.body
    end

    def get_headers(project)
      {
          "Accept": "application/vnd.github.v3+json",
          "User-Agent": project
      }
    end

    def query_string
      {:page => page, :per_page => per_page}
    end
  end
end

