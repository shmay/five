class CreateGamesGroups < ActiveRecord::Migration
  def change
    create_table :games_groups, :id => false do |t|
      t.references :group, :game
    end
  end
end
