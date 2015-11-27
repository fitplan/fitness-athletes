module Athlete
  class Base < ActiveRecord::Base
    extend FriendlyId
    friendly_id :title, use: :slugged

    self.table_name = :athletes

    belongs_to :user
    has_many :clicks, class_name: 'AthleteClick', foreign_key: :athlete_id

    validates :title, presence: true
    validates :user_id, presence: true
    validates :user, presence: true

    acts_as_votable
    acts_as_commentable
    acts_as_taggable

    scope :on_date, ->(date) { where 'athletes.created_at > ? AND athletes.created_at < ?', date, date + 1.day }
  end
end
