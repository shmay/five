class Event < ActiveRecord::Base
  has_many :statuses
  has_many :users, through: :statuses

  has_one :location

  has_and_belongs_to_many :games
  has_and_belongs_to_many :groups

  def self.all_events
    select('events.*', 'locations.city AS city',
           'locations.zip AS zip', 'array_agg(games.id) AS preloaded_game_ids').
    joins(%{
      LEFT JOIN "locations" ON "locations"."event_id" = "events"."id"
      LEFT JOIN "events_games" ON "events_games"."event_id" = "events"."id"
      LEFT JOIN "games" ON "games"."id" = "events_games"."game_id" }).
    group('events.id,locations.id')
  end
end
