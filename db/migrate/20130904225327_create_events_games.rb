class CreateEventsGames < ActiveRecord::Migration
  def change
    create_table :events_games, id: false do |t|
      t.references :event, :game
    end
  end
end
