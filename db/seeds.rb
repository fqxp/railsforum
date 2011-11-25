# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Post.delete_all
Talk.delete_all
Category.delete_all
User.delete_all

SALT = 'NaCl'
user = User.create(
  :username => 'frank',
  :realname => 'Frank',
  :password => 'hallo123',
  :language => 'de',
  :email_address => 'frank@localhost',
  :is_admin => false,
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
      :user => user
    )
    
    20.times do |j|
      begin
        Post.create(
          :text => "Was ich noch sagen wollte usw. #{i}/#{j}",
          :created_at => DateTime.new(2011, 11, 7, 0),
          :updated_at => DateTime.new(2011, 11, 8-rand(7).abs, 
            rand(24).abs, rand(60).abs, rand(60).abs),
          :talk_id => talk.id,
          :user => user
        )
#      rescue Exception => e
#        puts "Exception #{e}"
#e        puts "Date: #{h}:#{m}:#{s}"
      end
    end
  end
end
