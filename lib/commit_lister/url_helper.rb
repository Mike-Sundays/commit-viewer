require 'httparty'

class UrlHelper
  def self.get_owner(url)
    url.split('/')[-2]
  end

  def self.parse_project_name(url)
    url.split('/')[-1].split('.')[0]
  end

  def self.url_without_extension(url)
    url[0..-5]
  end

  def self.url_returns_ok?(url)
    url_without_extension = UrlHelper.url_without_extension(url)
    response = HTTParty.get(url_without_extension)
    response.code == 200 ? true : false
  end
end