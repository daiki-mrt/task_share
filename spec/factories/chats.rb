FactoryBot.define do
  factory :chat do
    text {Faker::Quote.matz}
    association :user
    association :community
  end
end
