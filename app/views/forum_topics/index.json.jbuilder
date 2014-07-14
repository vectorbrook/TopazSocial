json.array!(@forum_topics) do |forum_topic|
  json.extract! forum_topic, :title, :description, :posts_count, :hits, :sticky, :user_id
  json.url forum_topic_url(forum_topic, format: :json)
end
