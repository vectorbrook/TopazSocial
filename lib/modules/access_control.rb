require 'modules/acl'

module AccessControl

  def self.initialize_acl
    @@app_acl_ref = ACL.instance
  end

  module ClassMethods

    def list_acl
      #ACL.instance.list_acl
      (self.app_acl_ref ||= ACL.instance).list_acl
    end

    def add_to_acl(role,resource,actions)
      (self.app_acl_ref ||= ACL.instance).add_to_acl(role,resource,actions)
    end

    def remove_from_acl(roles,resources,actions)

    end

    def is_permitted(roles,action)
      (self.app_acl_ref ||= ACL.instance).is_permitted(roles,self.to_s,action)
    end

    def privilegify(*args)
      if args.size == 2
        privilegers = Util.arrayify args[0]
        actions = Util.arrayify args[1]
        privilegers.each do |privileger_|
          self.add_to_acl(privileger_,self.to_s,actions)
        end
      end
    end

    def default_privileges(*args)
      privilegify(DEFAULT_ROLES,*args)
    end

  end

  module InstanceMethods

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :cattr_accessor , :app_acl_ref
  end

end

