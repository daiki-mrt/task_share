FactoryBot.define do
  factory :message do
    text { Faker::Quote.matz }
    association :user
    association :room
  end
end
