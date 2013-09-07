class CreateGroupings < ActiveRecord::Migration
  def change
    create_table :groupings do |t|
      t.references :group, :user
      t.boolean :admin

      t.timestamps
    end
  end
end
