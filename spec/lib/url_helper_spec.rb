require './lib/commit_lister/url_helper'

RSpec.describe UrlHelper do
  context "given a valid url" do
    it "should extract project name" do
      url = "https://github.com/Mike-Sundays/simple-notes-react.git"
      result = UrlHelper.parse_project_name(url)
      expect(result).to eql("simple-notes-react")
    end

    it "should get owner" do
      url = "https://github.com/Mike-Sundays/simple-notes-react.git"
      result = UrlHelper.get_owner(url)
      expect(result).to eql("Mike-Sundays")
    end

    it "should get url without extension" do
      url = "https://github.com/Mike-Sundays/simple-notes-react.git"
      result = UrlHelper.url_without_extension(url)
      expect(result).to eql("https://github.com/Mike-Sundays/simple-notes-react")
    end
  end
end