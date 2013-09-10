class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :about
      t.references :user
      t.datetime :start_time
      t.datetime :finish_time

      t.timestamps
    end
  end
end
