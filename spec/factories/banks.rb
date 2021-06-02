FactoryBot.define do
  factory :bank do
    name {Faker::Company.name}
    #description {Faker::Lorem.paragraph}
    trait :has_page do
      has_page {true}
    end

    trait :no_page do
      has_page {false}
    end
  end
end