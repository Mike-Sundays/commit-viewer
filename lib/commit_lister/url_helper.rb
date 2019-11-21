class UrlHelper
  def self.get_owner(url)
    url.split('/')[-2]
  end

  def self.parse_project_name(url)
    url.split('/')[-1].split('.')[0]
  end
end