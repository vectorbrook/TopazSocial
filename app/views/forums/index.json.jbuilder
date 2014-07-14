json.array!(@forums) do |forum|
  json.extract! forum, :name, :description, :category, :topics_count, :posts_count, :position
  json.url forum_url(forum, format: :json)
end
