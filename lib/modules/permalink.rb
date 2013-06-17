module Permalink
  module ClassMethods

    def has_permalink_on(*args)
      self.permalink_field = args[0]
      options = args[1] || {}
      if options.has_key?(:parent)
        self.parent = options[:parent]
      end
    end

  end

  module InstanceMethods

    def check_permalink
      if self.changed.include? self.class.permalink_field.to_s
        self.permalink = make_permalink
      end
    end

    protected

    def make_permalink
      prefix_ = APP_URL
      if self.class.parent and self.send(self.class.parent).respond_to? :make_permalink
        prefix_ =  self.send(self.class.parent).make_permalink  + "/"
      end
      return prefix_ + self.send(self.class.permalink_field).parameterize
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :cattr_accessor , :permalink_field , :parent
    receiver.send :field, :permalink , :type => String
    receiver.send :before_save , :check_permalink
  end
end

