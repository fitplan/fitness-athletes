FactoryGirl.define do
  factory :athlete_base, class: Athlete::Base do
    user
    title { Faker::Lorem.sentence }
    # comment_threads { build_list :comment, rand(100) }
  end

  factory :athlete, class: Athlete::Link, parent: :athlete_base, aliases: [:link_athlete] do
    user
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    url { Faker::Internet.url }
    instagram_url { Faker::Internet.url }
  end

  factory :text_athlete, class: Athlete::Text, parent: :athlete_base do
    description { Faker::Lorem.sentence }
  end
end
