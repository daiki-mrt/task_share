FactoryBot.define do
  factory :answer do
    text { Faker::Quote.matz }
    association :user
    association :question
  end
end
