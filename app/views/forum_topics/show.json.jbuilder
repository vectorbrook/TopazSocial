json.array!(@posts) do |post|
  json.(post, :title, :content)
  json.url post_url(post, format: :json)
  json._id post.id.to_s
  json.forum_id post.forum_topic.forum.id.to_s
  json.forum_topic_id post.forum_topic.id.to_s
end
