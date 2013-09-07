class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :slug
      t.string :about

      t.references :user

      t.timestamps
    end

    add_index :games, :slug, unique: true
  end
end
