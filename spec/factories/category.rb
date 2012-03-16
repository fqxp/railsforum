FactoryGirl.define do

  factory :category do
    sequence :name do |n|
      "category_#{n}"
    end

    description 'This is a sample category'
  end
end
