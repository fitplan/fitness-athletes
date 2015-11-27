class AthleteClick < ActiveRecord::Base
  belongs_to :athlete, counter_cache: :clicks_count, class_name: 'Athlete::Base'
  belongs_to :user
  validates :athlete,    presence: true
  validates :athlete_id, presence: true
end
