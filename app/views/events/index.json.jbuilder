json.array!(@events) do |event|
  json.extract! event, :title, :about, :references, :when
  json.url event_url(event, format: :json)
end
