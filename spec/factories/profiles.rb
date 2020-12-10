FactoryBot.define do
  factory :profile do
    occupation_id { 1 }
    text { Faker::Quote.matz }
    association :user

    after(:build) do |profile|
      profile.image.attach(io: File.open("public/images/test_image.png"), filename: "test_image.png")
    end
  end

  factory :profile_with_occupation1, class: "Profile" do
    occupation_id { 1 }
    text { "プロフィールのテキスト" }
    association :user

    after(:build) do |profile|
      profile.image.attach(io: File.open("public/images/test_image.png"), filename: "test_image.png")
    end
  end

  factory :profile_with_occupation2, class: "Profile" do
    occupation_id { 2 }
    text { "プロフィールのテキスト" }
    association :user

    after(:build) do |profile|
      profile.image.attach(io: File.open("public/images/test_image.png"), filename: "test_image.png")
    end
  end

  factory :profile_with_occupation3, class: "Profile" do
    occupation_id { 3 }
    text { "プロフィールのテキスト" }
    association :user

    after(:build) do |profile|
      profile.image.attach(io: File.open("public/images/test_image.png"), filename: "test_image.png")
    end
  end

  factory :profile_with_other_introduction, class: "Profile" do
    occupation_id { 1 }
    text { "introduction" }
    association :user

    after(:build) do |profile|
      profile.image.attach(io: File.open("public/images/test_image.png"), filename: "test_image.png")
    end
  end
end
