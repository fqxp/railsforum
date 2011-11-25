class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.string :title
      t.integer :category_id

      t.timestamps
    end
  end
end
