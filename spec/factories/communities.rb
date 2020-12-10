FactoryBot.define do
  factory :community do
    sequence(:name) { |n| "コミュニティ名_#{n}" }
    text { "コミュニティの紹介文" }
    category_id { 1 }
    association :user
  end

  factory :community_with_category2, class: "Community" do
    sequence(:name) { |n| "コミュニティ名_#{n}" }
    text { "コミュニティの紹介文" }
    category_id { 2 }
    association :user
  end

  factory :community_with_category3, class: "Community" do
    sequence(:name) { |n| "コミュニティ名_#{n}" }
    text { "コミュニティの紹介文" }
    category_id { 3 }
    association :user
  end

  factory :community_with_other_name, class: "Community" do
    name { "community name" }
    text { "コミュニティの紹介文" }
    category_id { 1 }
    association :user
  end

  factory :community_with_other_introduction, class: "Community" do
    sequence(:name) { |n| "コミュニティ名_#{n}" }
    text { "community introduction" }
    category_id { 1 }
    association :user
  end
end
