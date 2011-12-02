class CreateTalkVisits < ActiveRecord::Migration
  def change
    create_table :talk_visits do |t|
      t.integer :talk_id
      t.integer :user_id
      t.datetime :last_visited

      t.timestamps
    end
  end
end
