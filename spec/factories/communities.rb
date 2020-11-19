FactoryBot.define do
  factory :community do
    sequence(:name) { |n| "コミュニティタイトル_#{n}" }
    text {Faker::Quote.matz}
    category_id { 1 }
    association :user
  end
end
