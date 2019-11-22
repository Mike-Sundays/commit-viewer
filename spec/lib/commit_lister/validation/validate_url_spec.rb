require './lib/commit_lister/validation/validate_url'

RSpec.describe CommitListerCli::ValidateUrl do
  it "should return true for valid url" do
    url = "https://github.com/Mike-Sundays/simple-notes-react.git"

    result = CommitListerCli::ValidateUrl.new(url).validate

    expect(result[:valid]).to eql(true)
  end

  it "should return true for valid url with www" do
    url = "https://www.github.com/Mike-Sundays/simple-notes-react.git"

    result = CommitListerCli::ValidateUrl.new(url).validate

    expect(result[:valid]).to eql(true)
  end

  it "should return false for url with no .git" do
    url = "https://github.com/Mike-Sundays/simple-notes-react"

    result = CommitListerCli::ValidateUrl.new(url).validate

    expect(result[:valid]).to eql(false)
  end

  it "should return false for url with no https" do
    url = "http://github.com/Mike-Sundays/simple-notes-react.git"

    result = CommitListerCli::ValidateUrl.new(url).validate

    expect(result[:valid]).to eql(false)
  end

  it "should return false for url not from github" do
    url = "https://gitfake.com/Mike-Sundays/simple-notes-react.git"

    result = CommitListerCli::ValidateUrl.new(url).validate

    expect(result[:valid]).to eql(false)
  end

  it "should return a failure for injected bash command" do
    url = "https://gitfake.com/Mike-Sundays/simple-notes-react.git && touch badfile.txt"

    result = CommitListerCli::ValidateUrl.new(url).validate

    expect(result[:valid]).to eql(false)
  end

  it "should return a failure for injected bash command variation" do
    url = "https://gitfake.com/Mike-Sundays/simple-notes-react.git&&pwd"

    result = CommitListerCli::ValidateUrl.new(url).validate

    expect(result[:valid]).to eql(false)
  end
end