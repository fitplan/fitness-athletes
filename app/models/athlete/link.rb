module Athlete
  class Link < Athlete::Base
    validates :instagram_url, presence: true
    validate :url_is_valid

    def url_is_valid
      uri = URI.parse(instagram_url)
      fail 'invalid URL' unless uri.scheme == 'https' || uri.scheme == 'http'
    rescue
      errors.add :instagram_url, 'is invalid'
    end
  end
end
