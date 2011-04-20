module Enablable

  module ClassMethods

  end

  module InstanceMethods

    def is_enabled?
      return enabled
    end

    def enable(user)
      return false unless Util.is_What(user,"User") and self.class.is_permitted(user.role,"enable")
      return change_enable_status("true",user)
    end

    def disable(user)
      return false unless Util.is_What(user,"User") and self.class.is_permitted(user.role,"disable")
      return change_enable_status("false",user)
    end

    protected

    def change_enable_status(status,user)
      return false unless status
      self.enabled = ( status == "true" ? true : false )
      return true
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :key, :enabled , Boolean , :default => true
  end

end

