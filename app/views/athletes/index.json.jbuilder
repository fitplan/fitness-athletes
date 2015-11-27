json.array!(@athletes) do |athlete|
  json.extract! athlete, :id, :title, :description, :url
  json.url athlete_url(athlete, format: :json)
end
