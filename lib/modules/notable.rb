module Notable
  
  module ClassMethods
    
  end

  module InstanceMethods

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :key, :notes , Array
  end
  
end

