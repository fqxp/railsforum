class AddDeviseInvitable < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
      t.invitable
    end
    add_index :users, :invitation_token
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
