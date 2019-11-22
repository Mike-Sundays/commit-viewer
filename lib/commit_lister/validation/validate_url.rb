require 'uri'
require 'net/http'
require_relative './validate_url_messages'

module CommitListerCli
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
        validation_result(false, ValidateUrlMessages::NO_HTTPS)

      elsif !valid_extension?(parsed_url)
        validation_result(false, ValidateUrlMessages::NO_GIT_EXTENSION)

      elsif !valid_host?(parsed_url)
        validation_result(false, ValidateUrlMessages::NOT_GITHUB)

      elsif !repo_exists?(url)
        validation_result(false, ValidateUrlMessages::NO_REPO)

      else
        validation_result(true, "")
      end
    rescue URI::Error => e
      validation_result(false, e.message)
    end

    def validation_result(valid, message)
      {:valid => valid, :error => message}
    end

    def parse
      # this avoids most injection cases
      URI.parse(url)
    end

    def repo_exists?(url)
      UrlHelper.url_returns_ok?(url)
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

