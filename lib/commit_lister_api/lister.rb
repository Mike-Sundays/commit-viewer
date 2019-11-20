require 'httparty'

module CommitListerApi
  class Lister
    attr_reader :url

    OWNER_PLACEHOLDER = ":owner"
    REPO_PLACEHOLDER = ":repo"
    URL_API = "https://api.github.com/repos/#{OWNER_PLACEHOLDER}/#{REPO_PLACEHOLDER}/commits"

    def initialize(url)
      @url = url
    end

    def run
      owner, project = get_owner, parse_project_name
      url = build_url(owner, project)
      response = request_github_api(url, project)
      parsed_response = JSON.parse(response)
      commits = extract_commits(parsed_response)
    end

    private

    def request_github_api(url, project)
      response = HTTParty.get(url, headers: {
          "Accept": "application/vnd.github.v3+json",
          "User-Agent": project
      })
      response.body
    end

    def get_owner
      url.split('/')[-2]
    end

    def parse_project_name
      url.split('/')[-1].split('.')[0]
    end

    def build_url(owner, project)
      url = URL_API.clone
      url.gsub!(OWNER_PLACEHOLDER, owner).
          gsub!(REPO_PLACEHOLDER, project)
    end

    def extract_commits(response)
      commits = []

      response.each do |element|
        commits << extract_parameters(element)
      end

      commits
    end

    def extract_parameters(element)
      commit = {}
      commit[:hash] = element["sha"]
      commit[:author] = element["commit"]["author"]["name"]
      commit[:message] = element["commit"]["message"]
      commit[:date] = element["commit"]["author"]["date"]
      commit
    end
  end
end
