class ACL
  include Singleton

  attr_accessor :app_acl

  def initialize
    @app_acl = Hash.new
  end

  def list_acl
    @app_acl
  end

  def add_to_acl(role,resource,actions)
    actions = ACTIONS if actions.include? "all"
    @app_acl[[role,resource]] = actions
  end

  def is_permitted(roles,resource,action)
    return !@app_acl.select { |k,v| (roles.include? k[0]) and (k[1] == resource) and (v.include? action) }.empty?
  end

end

