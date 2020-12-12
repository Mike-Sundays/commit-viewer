require 'result'
require 'httparty'
require_relative '../url_helper'
require_relative '../constants'

module CommitLister
  class ApiCommitGetter

    OWNER_PLACEHOLDER = ":owner"
    REPO_PLACEHOLDER = ":repo"
    URL_API = "https://api.github.com/repos/#{OWNER_PLACEHOLDER}/#{REPO_PLACEHOLDER}/commits"

    attr_reader :page, :per_page

    def initialize(page, per_page)
      @page = page
      @per_page = per_page
    end

    def run(url)
      begin
        owner, project = get_owner(url), parse_project_name(url)
        url_to_request = build_url(owner, project)
        response = request_github_api(url_to_request, project)

        Result.success(JSON.parse(response))
      rescue StandardError => e
        Result.failure(e.message, true)
      end
    end

    private

    def get_owner(url)
      UrlHelper.get_owner(url)
    end

    def parse_project_name(url)
      UrlHelper.parse_project_name(url)
    end

    def build_url(owner, project)
      url = URL_API.clone
      url.gsub!(OWNER_PLACEHOLDER, owner).
          gsub!(REPO_PLACEHOLDER, project)
    end

    def request_github_api(url_to_request, project)
      headers = build_request_headers(project)
      response = HTTParty.get(
          url_to_request, headers: headers,
          query: query_string,
          timeout: Constants::DEFAULT_TIMEOUT_SECONDS
      )
      response.body
    end

    def build_request_headers(project)
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

