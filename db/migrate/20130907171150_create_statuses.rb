class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses, id: false do |t|
      t.references :event, :user
      t.integer :status

      t.timestamps
    end
  end
end
