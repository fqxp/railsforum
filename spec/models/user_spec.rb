require 'spec_helper'

describe User do

  it 'should not be valid without a username' do
    user = Factory.build(:user, :username => nil)
    user.should_not be_valid
    user.username = 'username'
    user.should be_valid
  end

  it 'should not be valid without a realname' do
    user = Factory.build(:user, :realname => nil)
    user.should_not be_valid
    user.realname = 'User Name'
    user.should be_valid
  end

  it 'should not be valid without a language' do
    user = Factory.build(:user, :language => nil)
    user.should_not be_valid
    user.language = 'language'
    user.should be_valid
  end

  it 'should have a unique name' do
    Factory.create(:user, :username => 'username')

    expect {
      Factory.create(:user, :username => 'username')
    }.to raise_error(ActiveRecord::RecordInvalid, / has already been taken/)
  end

  it 'should be initialized with the default language if not given' do
    user = User.new
    user.language.should == I18n.default_locale
  end
end
