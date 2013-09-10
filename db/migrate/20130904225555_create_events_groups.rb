class CreateEventsGroups < ActiveRecord::Migration
  def change
    create_table :events_groups, id: false do |t|
      t.references :event, :group
    end
  end
end
