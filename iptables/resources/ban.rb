def initialize(name, run_context=nil)
  super(name, run_context)
  @action = :create
end

actions :create, :delete

attribute :port,  :kind_of => String
attribute :proto, :kind_of => String
