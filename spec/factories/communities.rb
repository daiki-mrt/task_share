FactoryBot.define do
  factory :community do
    sequence(:name) { |n| "コミュニティ名_#{n}" }
    text { "コミュニティの紹介文" }
    category_id { 1 }
    association :user
  end

  factory :community_category2 do
    sequence(:name) { |n| "コミュニティ名_#{n}" }
    text { "コミュニティの紹介文" }
    category_id { 2 }
    association :user
  end

  factory :community_category do
    sequence(:name) { |n| "コミュニティ名_#{n}" }
    text { "コミュニティの紹介文" }
    category_id { 3 }
    association :user
  end

  factory :community_with_other_introduction do
    sequence(:name) { |n| "コミュニティ名_#{n}" }
    text { "community introducion" }
    category_id { 1 }
    association :user
  end
end
