FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "taskのタイトル_#{n}"}
    sequence(:text) {Faker::Quote.matz}
    state { 0 }
    association :user
  end
end
