FactoryGirl.define do

  factory :post do
    association :user, :factory => :user
    association :talk, :factory => :talk

    text 'Sample text'
    created_at DateTime.new(2001, 2, 3, 4, 5, 6)
    updated_at DateTime.new(2001, 2, 3, 4, 5, 6)
  end
end
