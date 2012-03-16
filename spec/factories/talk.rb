FactoryGirl.define do

  factory :talk do
    title 'An interesting talk'
    created_at DateTime.new(2001, 2, 3, 4, 5, 6)
    updated_at DateTime.new(2001, 2, 3, 4, 5, 6)

    association :category, :factory => :category
    association :user, :factory => :user
  end
end
