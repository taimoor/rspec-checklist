FactoryBot.define do
  factory :restaurant do
    name sequence(:name) { |n| "name@@#{n}" }
    address sequence(:address) { |n| "address@@#{n}" }
    city sequence(:city) { |n| "city@@#{n}" }
  end
end
