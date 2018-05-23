# Factory models

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }
    first_name "Nazar"
    last_name "Hussain"
    password "secret_password"

    ignore do
      meetings_count 5
    end

    factory :user_with_meetings do
      after(:create) do |user, evaluator|
        2.times do
          meeting = FactoryGirl.create(:meeting, user: user)
        end
      end
    end
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    sequence(:email) { |n| "test#{n}@test.com" }
    first_name "Admin"
    last_name "User"
    password "secret_password"
    admin true
  end

end