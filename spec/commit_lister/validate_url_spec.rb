require './lib/commit_lister/validate_url'

describe CommitLister::ValidateUrl do
  it "should return true for valid url" do
    url = "https://github.com/Mike-Sundays/simple-notes-react.git"

    result = CommitLister::ValidateUrl.new(url).validate[:valid]

    expect(result).to eql(true)
  end

  it "should return false for url with no .git" do
    url = "https://github.com/Mike-Sundays/simple-notes-react"

    result = CommitLister::ValidateUrl.new(url).validate[:valid]

    expect(result).to eql(false)
  end

  it "should return false for url with no https" do
    url = "http://github.com/Mike-Sundays/simple-notes-react"

    result = CommitLister::ValidateUrl.new(url).validate[:valid]

    expect(result).to eql(false)
  end

  it "should return false for url not from github" do
    url = "https://gitfake.com/Mike-Sundays/simple-notes-react"

    result = CommitLister::ValidateUrl.new(url).validate[:valid]

    expect(result).to eql(false)
  end
end