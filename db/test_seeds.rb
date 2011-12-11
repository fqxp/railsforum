# This file contains test data creation statements to be used to
# test the forum with a number of categories,
# users, talks and posts already created. This gives a more
# realistic impression of the layout and functionality. 

Post.delete_all
TalkVisit.delete_all
Talk.delete_all
Category.delete_all
User.delete_all

SALT = 'NaCl'
users = []
users << User.create(
  :username => 'admin',
  :realname => 'Administrator',
  :password => 'verysecret!',
  :language => 'en',
  :email_address => 'root@localhost',
  :is_admin => true,
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
12.times do |i|
  category_number = i + 1
  categories << Category.create(
    :name => "Sample category #{category_number}",
    :description => %{
      Just a sample category (##{category_number}).
    }
  )
end

filler_text =<<EOF
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor 
invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et 
accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata 
sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing 
elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, 
sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita 
kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
EOF
categories.each do |category|
  (rand(50)+1).times do |i|
    talk = Talk.create(
      :title => "Talk #{i}",
      :category_id => category.id,
      :user => users[rand 3]
    )
    
    (rand(25)+1).times do |j|
      begin
        Post.create(
          :text => filler_text[0, rand(filler_text.length)],
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
