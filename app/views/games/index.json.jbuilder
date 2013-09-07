json.array!(@games) do |game|
  json.extract! game, :name, :slug, :info
  json.url game_url(game, format: :json)
end
