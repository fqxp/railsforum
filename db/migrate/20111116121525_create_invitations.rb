class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email_address
      t.string :confirm_key
      t.integer :invited_by_id

      t.timestamps
    end
  end
end
