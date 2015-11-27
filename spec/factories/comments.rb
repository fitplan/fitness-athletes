FactoryGirl.define do
  factory :comment do
    user
    commentable { create :athlete }
    body { Faker::Lorem.sentence }
  end
end
