class AddStuffToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :info, :text
  end
end
