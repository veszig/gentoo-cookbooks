def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @action = :create
end

actions :create, :delete

attribute :source,    :kind_of => String
attribute :cookbook,  :kind_of => String
attribute :variables, :kind_of => Hash
