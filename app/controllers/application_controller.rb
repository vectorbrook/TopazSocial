class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user , :is_twitter_enabled? , *(ALL_ROLES - ["user"]).map { |m| [:"is_#{m}?"] }.flatten
  #rescue_from Exception, :with => :rescue_all_exceptions

  TWITTER_ENABLED = false

  def is_twitter_enabled?
    @twitter_enabled ||= (TWITTER_CONSUMER_KEY and !TWITTER_CONSUMER_KEY.blank?)
  end

  def require_user
    #return current_user ? true : false
    if !current_user
      redirect_to login_path
    end
  end

  (ALL_ROLES - ["user"]).each do |role|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def is_#{role}?
        return current_user ? current_user.is_#{role}? : false
      end
      def require_#{role}
        if !is_#{role}?
          redirect_to root_url
        end
      end
    METHODS
  end
  
  def require_admin
    if !(current_user and current_user.role.include?("admin"))
      flash[:notice] = "You need to be an admin."
   
      redirect_to root_url
    end
  end
  
=begin
  def rescue_all_exceptions(exception)
    p exception.message
    p exception.backtrace
    case exception
    when Mongoid::Errors::DocumentNotFound
        flash[:notice] = "The requested resource was not found."
      when ActionController::RoutingError, ActionController::UnknownController, ActionController::UnknownAction
        flash[:notice] =  "Invalid request."
      when Twitter::Error::Unauthorized
        session[:twitter_token] = nil
        flash[:notice] = "Your twitter session has expired."
      else
        p exception.message
        p exception.backtrace
        flash[:notice] =   "An internal error has occurred. Sorry for the inconvenience."
    end
    redirect_to root_url
  end
=end
end
