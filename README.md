Railsforum
==========
For now, this is a very simple forum web application written in Ruby on Rails.

Features:

* write articles
* log in, log out, invite users
* edit user settings, including avatar upload

Prerequisites
-------------
This application was developed with Ruby 1.9.2. and Rails 3.1. It won't work with earlier versions.

Installation
------------
Clone the repository:

    git clone git://github.com/frankploss/railsforum.git

It makes sense to set up [RVM](http://beginrescueend.com/rvm/install/) if 
you haven't done so yet. Then, install dependencies:

    bundle install

Set up database:

    cp config/database.yml.sample config/database.yml
    vi config/database.yml    # adjust to your needs
    rake db:migrate
    rake db:seed

Try it out:

    rails server
    
Visit [http://localhost:3000](http://localhost:3000) and log in as `admin` with password `verysecret!`.
