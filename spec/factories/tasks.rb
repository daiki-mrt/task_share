FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "taskのタイトル_#{n}" }
    sequence(:text) { Faker::Quote.matz }
    state { 0 }
    association :user
  end

  factory :completed_task, class:"Task" do
    sequence(:title) { |n| "taskのタイトル_#{n}" }
    sequence(:text) { Faker::Quote.matz }
    state { 1 }
    association :user
  end

  factory :not_completed_task, class:"Task" do
    sequence(:title) { |n| "taskのタイトル_#{n}" }
    sequence(:text) { Faker::Quote.matz }
    state { 0 }
    association :user
  end
end
