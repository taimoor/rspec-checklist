# Factory models

FactoryBot.define do
  factory :user do
    email 't@t.com'
    # sequence(:email) { |n| "test0#{n}@test.com" }
    password "password1"
    password_confirmation "password1"
  end
end