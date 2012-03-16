require 'spec_helper'

describe Category do

  it 'should not be valid without a name' do
    category = Factory.build(:category, :name => nil)

    category.should_not be_valid
    category.name = 'category'
    category.should be_valid
  end

  it 'should not be valid without a description' do
    category = Factory.build(:category, :description => nil)

    category.should_not be_valid
    category.description = 'A new description'
    category.should be_valid
  end

  it 'should have a unique name' do
    Factory.create(:category, :name => 'Category')

    expect {
      Factory.create(:category, :name => 'Category')
    }.to raise_error(ActiveRecord::RecordInvalid, / has already been taken/)
  end
end
