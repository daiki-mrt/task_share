FactoryBot.define do
  factory :profile do
    occupation_id {1}
    text {Faker::Quote.matz}
    association :user
    
    after(:build) do |item|
      item.image.attach(io: File.open("public/images/test_image.png", filename: "test_image.png"))
    end
  end
end
