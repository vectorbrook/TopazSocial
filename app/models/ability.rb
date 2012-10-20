class Ability
  include CanCan::Ability

  def initialize(app_user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    
    app_user ||= User.new(:role => ["guest"])
    
    app_user.role.each { |role| send(role) }
    
  end

  def admin
    #employee
    can :manage, :all
  end
  
  def approver
    employee
  end
  
  def moderator
    employee
  end
  
  def sales_manager
    sales_engineer
  end
  
  def sales_engineer
    employee
  end
  
  def support_manager
    support_agent
    can :manage, ServiceCase
    can [:read,:create], ForumTopic
    can [:read,:create,:update], ForumPost
    can :read, [CustomerAccount,CustomerSite,CustomerContact]
  end
  
  def support_agent
    employee
  end
  
  def prospect
    user
  end
  
  def customer
    user
  end
  
  def guest
    #can :welcome, :everyone
    can :sign, :out
  end
  
  def social_media_manager
    employee
  end
  
  def community_manager
    approver
    moderator
  end
  
  def user
    guest
    #can? :welcome, :everyone
    can :quick, :find
    #can :sign, :out
    can :read, CmPage
  end
  
  def employee
    #can? :welcome, :everyone
    user
  end
  
end
