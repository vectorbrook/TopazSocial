module OmniAuth
  module Strategies
    class TwitterWithExceptionHandling < OmniAuth::Strategies::Twitter
      def call
        begin
          super
        raise OmniAuth::Unauthorized => e
          #handle appropriately in rack context here          
          redirect_to '/', :notice => "Oauth error."
        end
      end
    end
  end
end

