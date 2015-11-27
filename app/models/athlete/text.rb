module Athlete
  class Text < Athlete::Base
    validates :description, presence: true
  end
end
