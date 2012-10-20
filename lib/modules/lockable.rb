module Lockable

  module ClassMethods

  end

  module InstanceMethods

    def is_locked?
      return locked
    end

    def lock(user)
      return false unless Util.is_What(user,"User") #and can?(:lock, self) #self.class.is_permitted(user.role,"lock")
      return change_lock_status("true",user)
    end

    def unlock(user)
      return false unless Util.is_What(user,"User") #and can?(:unlock, self) #self.class.is_permitted(user.role,"unlock")
      return change_lock_status("false",user)
    end

    protected

    def change_lock_status(status,user)
      return false unless status
      self.locked = ( status == "true" ? true : false )
      return true
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :key, :locked, Boolean, :default => false
  end

end

