json.array!(@posts) do |post|
  json.(post, :body, :description)
  json.url forum_forum_topic_forum_post_url(@forum,@forum_topic,post, format: :json)
  json._id post.id.to_s
  json.forum_id post.forum_topic.forum.id.to_s
  json.forum_topic_id post.forum_topic.id.to_s
end
