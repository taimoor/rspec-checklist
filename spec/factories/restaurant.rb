FactoryBot.define do
  factory :restaurant do
    name sequence(:name) { |n| "Restaurant@@#{n}" }
    address sequence(:address) { |n| "address@@#{n}" }
    city sequence(:city) { |n| "city@@#{n}" }
  end
end
