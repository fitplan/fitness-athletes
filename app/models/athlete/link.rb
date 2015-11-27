module Athlete
  class Link < Athlete::Base
    validates :url, presence: true
    validates :instagram_url, presence: true
    validate :url_is_valid

    def url_is_valid
      uri = URI.parse(url) || URI.parse(instagram_url)
      fail 'invalid URL' unless uri.scheme == 'https' || uri.scheme == 'http'
    rescue
      errors.add :url, 'is invalid'
      errors.add :instagram_url, 'is invalid'
    end
  end
end
