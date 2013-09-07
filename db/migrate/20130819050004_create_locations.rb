class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :zip
      t.decimal :lat,  :precision => 15, :scale => 10
      t.decimal :lng,  :precision => 15, :scale => 10
      t.string :city
      t.string :state
      t.string :country

      t.references :group, :user

      t.timestamps
    end

    add_index  :locations, [:lat, :lng]
  end
end
