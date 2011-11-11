class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :hashed_password
      t.string :realname
      t.string :email_address
      t.string :salt

      t.timestamps
    end
  end
end
