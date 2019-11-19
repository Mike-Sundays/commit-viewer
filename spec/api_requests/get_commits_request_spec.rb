require "rails_helper"

RSpec.describe "get commits from repo endpoint", :type => :request do
  context "given a valid url in request" do
    it "returns a list of commits" do
      repo_url = "https://github.com/Mike-Sundays/simple-notes-react.git"
      query_string = "?url=#{repo_url}"

      get "/commits/#{query_string}"

      result = JSON.parse(response.body)["data"]

      first_commit = result.first

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(200)

      expect(result).to be_instance_of(Array)

      expect(first_commit).to be_instance_of(Hash)
      expect(first_commit.keys).to match_array(%w(hash message author date))
    end
  end

  context 'given an invalid url' do
    it 'returns a bad request response' do
      repo_url = "http://github.com/Mike-Sundays/simple-notes-react.git"
      query_string = "?url=#{repo_url}"

      get "/commits/#{query_string}"

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(400)
    end
  end

end