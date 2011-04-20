class CustomFailure < Devise::FailureApp
  def redirect_url
    root_url #new_user_session_url(:subdomain => 'secure')
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
