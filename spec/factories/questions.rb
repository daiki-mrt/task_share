FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "質問タイトル_#{n}"}
    content {Faker::Quote.matz}
    state { 0 }
    association :user
    association :community

    after(:build) do |item|
      item.image.attach(io: File.open("public/images/test_image.png", filename: "test_image.png"))
    end    
  end
end
