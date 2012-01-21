# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# This only sets up an admin account and a small number of categories.

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
  :email => 'root@traal.ath.cx',
  :is_admin => true,
  :avatar => File.open('public/images/avatar-default.png')
)

categories = []
5.times do |i|
  category_number = i + 1
  categories << Category.create(
    :name => "Sample category #{category_number}",
    :description => %{
      Just a sample category (##{category_number}).
    }
  )
end
