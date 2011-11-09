# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Post.delete_all
Talk.delete_all
Topic.delete_all

topics = []
topics << Topic.create(
  :name => 'Kung Fu',
  :description => %{
    Alles, was mit Kung Fu- und Sanda zu tun hat.
  }
)

topics << Topic.create(
  :name => 'Yoga',
  :description => %{
    Yogis unterhalten sich hier.
  }
)

topics << Topic.create(
  :name => 'Street Talk',
  :description => %{
    Was nirgendwo anders reinpasst, kann hier besprochen werden.
  }
)

topics.each do |topic|
  100.times do |i|
    talk = Talk.create(
      :title => "Talk #{i}",
      :started_at => nil,
      :topic_id => topic.id
    )
    
    50.times do |j|
      begin
        Post.create(
          :text => "Was ich noch sagen wollte usw. #{i}/#{j}",
          :created_at => DateTime.new(2011, 11, 7, 0),
          :updated_at => DateTime.new(2011, 11, 8-rand(7).abs, 
            rand(24).abs, rand(60).abs, rand(60).abs),
          :talk_id => talk.id
        )
#      rescue Exception => e
#        puts "Exception #{e}"
#e        puts "Date: #{h}:#{m}:#{s}"
      end
    end
  end
end
