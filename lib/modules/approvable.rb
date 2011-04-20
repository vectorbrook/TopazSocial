module Approvable
  module ClassMethods

  end

  module InstanceMethods

    def is_approved?
      return approved
    end

    def has_been_approved?
      return approved_by != nil
    end

    def approve(user)
      return false unless Util.is_What(user,"User") and self.class.is_permitted(user.role,"approve")
      return change_approval_status("true",user)
    end

    def disapprove(user)
      return false unless Util.is_What(user,"User") and self.class.is_permitted(user.role,"disapprove")
      return change_approval_status("false",user)
    end

    protected

    def change_approval_status(status,user)
      return false unless status
      self.approved_by = user.id.to_s
      self.approved = ( status == "true" ? true : false )
      return true
    end

    def check_approval
      if self.changed.include? 'approved'
        if self.approved_by
          u = User.find self.approved_by
          return true if u and self.class.is_permitted(u.role,"approve")
        end
      end
      errors.add_to_base "Approval status wrongly modified."
      return false
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :key, :approved, Boolean, :required => true , :default => false
    receiver.send :key, :approved_by , ObjectId
    receiver.send :before_save , :check_approval
  end
end

