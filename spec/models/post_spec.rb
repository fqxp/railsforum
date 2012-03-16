require 'spec_helper'

describe Post do

  it 'should not be valid without a text' do
    post = Factory.build(:post, :text => nil)
    post.should_not be_valid
    post.text = 'Some text'
    post.should be_valid
  end

  it 'should not be valid without a talk' do
    post = Factory.build(:post, :talk => nil)
    post.should_not be_valid
    post.talk = Factory.create(:talk)
    post.should be_valid
  end

end
