class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.references :event, :user
      t.integer :status

      t.timestamps
    end
  end
end
