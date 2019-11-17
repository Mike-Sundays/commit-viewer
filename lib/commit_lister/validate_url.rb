require 'uri'
require 'net/http'

module CommitLister
  # valid link is an https link as provided in download
  # button in online repository
  class ValidateUrl
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def validate
      parsed_url = parse
      if !valid_https?(parsed_url)
        {:valid => false, :error => "URL is not using HTTPS"}
      elsif !valid_extension?(parsed_url)
        {:valid => false, :error => "URL does not contain .git extension"}
      elsif !valid_host?(parsed_url)
        {:valid => false, :error => "URL is not from Github"}
      else
        {:valid => true, :error => ""}
      end
    end

    def parse
      URI.parse(url)
    end

    def valid_https?(parsed_url)
      parsed_url.scheme == "https"
    end

    def valid_extension?(parsed_url)
      parsed_url.path.split('.')[-1] == "git"
    end

    def valid_host?(parsed_url)
      parsed_url.host == "github.com"
    end
  end
end

