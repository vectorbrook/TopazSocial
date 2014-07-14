class UsersController < ApplicationController
  
  before_action :require_admin, :only => [:show, :employees, :non_employees, :customers, :edit_employee, :disable_user, :enable_user]

  def show
    @user = User.find(params[:id])
  end
  
  def employees
    @users = User.employees.all
  end

  def non_employees
    @users = User.all - User.where(:role => "employee").all - User.customers.all
  end
  
  def customers
    @users = User.customers.all
  end

  def edit_employee
    p "sssssss"
    @user = User.find params[:id]
    p @user
    if request.put?
      p "rrrrrrrr"
      p params[:user]["role"]
      #params[:user]["role"] = Util.add_default_roles(params[:user]["role"])
      if @user.update(user_params)
         p "sssss"
         p @user
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
   
  def find_users
    params[:r]
    nm = {}
    if params[:r]
      nm = {:name => /#{params[:r]}/i }
      @users = User.where(nm)
    else
      @users = nil
    end
    @followings = User.find current_user.followings
    p @followings
    @followers = User.find current_user.followers
  end
  
  def show_profile
    @user = User.where(:id => params[:id]).first
  end 
  
  def follow
    user = User.where(:id => params[:id]).first
    if user
      # check if the user has blocked the current_user
       if(!user.blocked_users.include?(current_user.id))
         current_user.followings << user.id 
         user.followers << current_user.id
         user.save
         current_user.save 
       end
    end   
    redirect_to find_users_path
  end 
  
  
  def unfollow
    p current_user
    p "ccccccccc"
    p "111111111"
    p params
    p "2222222"
    user = User.where(:id => params[:id]).first
    p user
    p "3333333"
    if user
         p "uuuuuuuuuuuu"
         p user.id
         p "ssssssss"
         current_user.followings.delete(user.id) 
         p  current_user.followings 
         p "ffffffffff"
         user.followers.delete(current_user.id)
         user.save
         p "4444"
         p user
         p "5555"
         current_user.save 
         p "666666"
         p  current_user 
         p "77777777"
    end   
    redirect_to find_users_path
  end
  
  def block_user

    user = User.where(:id => params[:id]).first
    if user
     p "uuuuuuuuuuuu"
     p user.id
     p "ssssssss"
     current_user.blocked_users << user.id 
     p  current_user.blocked_users
     p "4444"
     current_user.save 
     p "666666"
     p  current_user 
     p "77777777"
    end   
    redirect_to find_users_path
  end
  
  private
 
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_me, :provider, :uid, :role => [])
    end
end
