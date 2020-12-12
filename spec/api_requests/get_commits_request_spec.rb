require "rails_helper"

RSpec.describe "get commits from repo endpoint", :type => :request do
  context "given a valid url in request" do
    it "returns a default list of commits" do
      repo_url = "https://github.com/Mike-Sundays/simple-notes-react.git"
      query_string = "?url=#{repo_url}"

      get "/commits/#{query_string}"

      result = JSON.parse(response.body)["data"]

      first_commit = result.first

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(200)

      expect(result).to be_instance_of(Array)

      expect(first_commit).to be_instance_of(Hash)
      expect(first_commit.keys).to include("hash", "message", "author", "date")
      expect(result.size).to eql(10)
    end
  end

  context "given a valid url in request and page options" do
    it "returns a paginated list of commits with those options" do
      repo_url = "https://github.com/Mike-Sundays/simple-notes-react.git"
      per_page = 5
      page = 2

      query_string = "?url=#{repo_url}&page=#{page}&per_page=#{per_page}"

      get "/commits/#{query_string}"

      result = JSON.parse(response.body)["data"]

      first_commit = result.first

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(200)
      expect(result).to be_instance_of(Array)
      expect(first_commit).to be_instance_of(Hash)
      expect(first_commit.keys).to include("hash", "message", "author", "date")
      expect(result.size).to eql(per_page)
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

  context 'given an non existing repo' do
    it 'returns a bad request response response' do
      repo_url = "http://github.com/Mike-Sundays/fake.git"
      query_string = "?url=#{repo_url}"

      get "/commits/#{query_string}"

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(400)
    end
  end

  context 'given an injected command' do
    it 'returns a bad request response ' do
      repo_url = "http://github.com/Mike-Sundays/simple-notes-react.git&&pwd"
      query_string = "?url=#{repo_url}"

      get "/commits/#{query_string}"

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(400)
    end
  end

end