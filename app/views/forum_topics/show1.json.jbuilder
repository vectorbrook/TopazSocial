json.array!(@posts) do |post|
  json.(post, :title, :content)
  json.url post_url(post, format: :json)
  json._id post.id.to_s
end
