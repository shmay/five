class CreatePlayings < ActiveRecord::Migration
  def change
    create_table :playings do |t|
      t.references :game, :user

      t.timestamps
    end
  end
end
