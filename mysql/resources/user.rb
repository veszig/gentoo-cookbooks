# http://dev.mysql.com/doc/refman/5.0/en/create-user.html
def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @action = :create
end

actions :create, :delete

attribute :host,           :kind_of => String, :default => "localhost"
attribute :password,       :kind_of => String
attribute :force_password, :kind_of => [TrueClass, FalseClass], :default => false
