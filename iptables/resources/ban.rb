def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @action = :create
end

actions :create, :delete

attribute :port,  :kind_of => String
attribute :proto, :kind_of => String
