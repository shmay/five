class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :user, :group, :event
      t.integer :invitee_id

      t.timestamps
    end
  end
end
