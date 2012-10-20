class UsersController < ApplicationController
  
  load_and_authorize_resource
  
  #before_filter :require_admin , :only => [:employees,:non_employees,:edit_employee,:enable_user,:disable_user]
  #before_filter :require_user , :only => [:follow,:unfollow,:remove_follower,:accept,:decline,:clear_provider_details,:social]
  #before_filter :require_employee , :only => [:my_cases]

  def employees
    @users = User.where(:role => "employee").all
  end

  def non_employees
    @users = User.all - User.where(:role => "employee").all
  end

  def edit_employee
    @user = User.find params[:id]
    if request.put?
      params[:user]["role"] = Util.add_default_roles(params[:user]["role"])
      if @user.update_attributes(params[:user])
        redirect_to employees_path
      else
        render :edit_employee
      end
    else
      render :edit_employee
    end
  end

  def disable_user
    user = User.find params[:id]
    if user
      user.locked_at = Time.now
      user.save
    end
    if user.is_employee?
      redirect_to employees_path
    else
      redirect_to root_url
    end
  end

  def enable_user
    user = User.find params[:id]
    user.unlock_access! if user
    if user.is_employee?
      redirect_to employees_path
    else
      redirect_to root_url
    end
  end

  (%w[follow unfollow remove_follower accept decline]).each do |user_action|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def #{user_action}
        begin
          current_user.send( #{user_action}.to_sym,( params[:id] || nil ) )
        rescue Exception => e
          #TODO
        end
        redirect_to root_url
      end
    METHODS
  end

  def clear_provider_details
    _user = ( params[:id] == current_user.id ) ? current_user : User.find( params[:id])
    if _user and _user.can_clear_provider_account?
      User::PROVIDER_FIELDS.each do |f|
        _user.send("#{params[:provider]}_#{f}=".to_sym, nil)
      end
      _user.save
      flash[:notice] = "#{params[:provider].camelize} association cleared."
    else
      if _user
        flash[:notice] = "How will you login? Sorry. Can't burn this bridge."
      else
        flash[:notice] = "Could not find the account. Try again."
      end
    end
    redirect_to :back
  end
  
  def social
    @twitter_avlbl = false
    if current_user and session[:twitter_token] and !session[:twitter_token].blank?
      @twitter_avlbl = true
      @lists = []
      @lists = current_user.twitter_client.mentions
    end
  end
  
  def do_tweet
    if current_user and session[:twitter_token] and !session[:twitter_token].blank? and !params[:content].blank?
      current_user.twitter_client.update(params[:content])
    end
    redirect_to social_path
  end

end

