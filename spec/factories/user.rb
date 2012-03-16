FactoryGirl.define do

  factory :user do
    sequence :username do |n|
      "user_#{n}"
    end

    sequence :email do |n|
      "user_#{n}@example.org"
    end

    realname 'User'
    password 'mysecret'
    is_admin false
    language 'de'
  end
end
