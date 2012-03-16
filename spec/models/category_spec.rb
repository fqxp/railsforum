require 'spec_helper'

describe Category do
  before do
  end

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
    Factory.create(:category)

    expect {
      Factory.create(:category)
    }.to raise_error(ActiveRecord::RecordInvalid, /Name has already been taken/)
  end
end
