require 'spec_helper'

describe Talk do

  it 'should not be valid without a title' do
    category = Factory.build(:talk, :title => nil)

    category.should_not be_valid
    category.title = 'A proper title'
    category.should be_valid
  end

  it 'should not be valid without a category' do
    category = Factory.build(:talk, :category => nil)

    category.should_not be_valid
    category.category = FactoryGirl.create(:category)
    category.should be_valid
  end

  context 'with some content' do

    before do
      @user = Factory.create(:user)

      @talk_1 = Factory.create(:talk, :title => 'Talk 1')
      @talk_2 = Factory.create(:talk, :title => 'Talk 2')
      @talk_3 = Factory.create(:talk, :title => 'Talk 3')

      @post_1_1 = Factory.create(:post, :talk => @talk_1, :updated_at => DateTime.new(2002, 2, 3, 0, 0, 0))
      @post_2_1 = Factory.create(:post, :talk => @talk_2, :updated_at => DateTime.new(2002, 2, 4, 0, 0, 0))
      @post_3_1 = Factory.create(:post, :talk => @talk_3, :updated_at => DateTime.new(2002, 2, 5, 0, 0, 0))
    end

    describe 'talks_with_user_specific_info' do
      it 'should return a list of talks sorted by last post' do
        talks = Talk.talks_with_user_specific_info(@user.id)

        talks.first.id.should == @talk_3.id
        talks.second.id.should == @talk_2.id
        talks.third.id.should == @talk_1.id
      end

      it 'should add count_posts to each talk' do
        talks = Talk.talks_with_user_specific_info(@user.id)

        talks.first.count_posts.should == 1
      end

      it 'should add number of unread posts to each talk' do
        Talk.should_receive(:'count_unread_posts').with(@talk_3.id, @user.id).and_return(42)
        Talk.should_receive(:'count_unread_posts').with(@talk_2.id, @user.id).and_return(42)
        Talk.should_receive(:'count_unread_posts').with(@talk_1.id, @user.id).and_return(42)

        talks = Talk.talks_with_user_specific_info(@user.id)
        talks.first.count_unread_posts.should == 42
      end
    end

    describe '#mark_visited' do
      it 'should create a new TalkVisit record if none existed' do
        TalkVisit.find_by_talk_id_and_user_id(@talk_1.id, @user.id).should be_nil
        @talk_1.mark_visited(@user.id)
        TalkVisit.find_by_talk_id_and_user_id(@talk_1.id, @user.id).should_not be_nil
      end

      it 'should update the visit time of an existing TalkVisit record if one existed' do
        talk_visit = Factory.create(:talk_visit, :talk => @talk_1, :user => @user)
        @talk_1.mark_visited(@user.id)
        datetime_before = talk_visit.last_visited
        talk_visit.reload
        datetime_before.should < talk_visit.last_visited
      end
    end

    describe 'count_unread_posts' do
      it 'should return the number of unread posts of a given talk' do
        Talk.count_unread_posts(@talk_1.id, @user.id).should == 1
        @talk_1.mark_visited(@user.id)
        Talk.count_unread_posts(@talk_1.id, @user.id).should == 0
      end
    end

  end
end
