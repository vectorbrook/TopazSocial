class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user , :is_twitter_enabled? , *(ALL_ROLES - ["user"]).map { |m| [:"is_#{m}?"] }.flatten 
  rescue_from Exception, :with => :rescue_all_exceptions
  
  check_authorization :unless => :devise_controller?

  
  TWITTER_ENABLED = false

  def is_twitter_enabled?
    @twitter_enabled ||= (TWITTER_CONSUMER_KEY and !TWITTER_CONSUMER_KEY.blank?)
  end

  def require_user
    #return current_user ? true : false
    if !current_user
      redirect_to root_url
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

  def rescue_all_exceptions(exception)
    p exception.message
    p exception.backtrace
    case exception
    when MongoMapper::DocumentNotFound
        flash[:notice] = "The requested resource was not found."
      when ActionController::RoutingError, ActionController::UnknownController, ActionController::UnknownAction
        flash[:notice] =  "Invalid request."
      when Twitter::Error::Unauthorized
        session[:twitter_token] = nil
        flash[:notice] = "Your twitter session has expired."
      when CanCan::AccessDenied
        flash[:notice] = exception.message  
      else
        p exception.message
        p exception.backtrace
        flash[:notice] =   "An internal error has occurred. Sorry for the inconvenience."
    end
    redirect_to root_url
  end 

end

