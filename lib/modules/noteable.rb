module Noteable

  module ClassMethods

  end

  module InstanceMethods

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :field, :notes , :type => Array
  end

end
