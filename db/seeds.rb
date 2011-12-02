# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Post.delete_all
TalkVisit.delete_all
Talk.delete_all
Category.delete_all
User.delete_all

SALT = 'NaCl'
users = []
users << User.create(
  :username => 'frank',
  :realname => 'Frank',
  :password => 'hallo123',
  :language => 'de',
  :email_address => 'frank@localhost',
  :is_admin => false,
  :avatar => File.open('public/images/avatar-default.png')
)
users << User.create(
  :username => 'testuser1',
  :realname => 'Test User 1',
  :password => 'hallo123',
  :language => 'de',
  :email_address => 'frank@localhost',
  :is_admin => false,
  :avatar => File.open('public/images/avatar-default.png')
)
users << User.create(
  :username => 'testuser2',
  :realname => 'Test User 2',
  :password => 'hallo123',
  :language => 'de',
  :email_address => 'frank@localhost',
  :is_admin => false,
  :avatar => File.open('public/images/avatar-default.png')
)

categories = []
categories << Category.create(
  :name => 'Kung Fu',
  :description => %{
    Alles, was mit Kung Fu- und Sanda zu tun hat.
  }
)

categories << Category.create(
  :name => 'Yoga',
  :description => %{
    Yogis unterhalten sich hier.
  }
)

categories << Category.create(
  :name => 'Street Talk',
  :description => %{
    Was nirgendwo anders reinpasst, kann hier besprochen werden.
  }
)

categories.each do |category|
  50.times do |i|
    talk = Talk.create(
      :title => "Talk #{i}",
      :category_id => category.id,
      :user => users[rand 3]
    )
    
    20.times do |j|
      begin
        Post.create(
          :text => "Was ich noch sagen wollte usw. #{i}/#{j}",
          :created_at => DateTime.new(2011, 11, 7, 0),
          :updated_at => DateTime.new(2011, 11, 8-rand(7).abs, 
            rand(24).abs, rand(60).abs, rand(60).abs),
          :talk_id => talk.id,
          :user => users[rand 3]
        )
      end
    end
  end
end
