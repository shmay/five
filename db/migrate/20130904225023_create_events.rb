class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :about
      t.references :user
      t.date :when

      t.timestamps
    end
  end
end
