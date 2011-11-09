class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.string :title
      t.datetime :started_at
      t.integer :topic_id

      t.timestamps
    end
  end
end
