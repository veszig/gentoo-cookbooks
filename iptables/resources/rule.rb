def initialize(name, run_context=nil)
  super(name, run_context)
  @action = :create
end

actions :create, :delete

attribute :source,    :kind_of => String
attribute :cookbook,  :kind_of => String
attribute :variables, :kind_of => Hash
