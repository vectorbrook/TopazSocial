Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_CONSUMER_KEY , TWITTER_CONSUMER_SECRET
  provider :facebook, FB_APP_ID, FB_APP_SECRET
end
