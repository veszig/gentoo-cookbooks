# http://dev.mysql.com/doc/refman/5.0/en/create-database.html
def initialize(name, run_context=nil)
  super(name, run_context)
  @action = :create
end

actions :create, :delete

attribute :owner,      :kind_of => String
attribute :owner_host, :kind_of => String, :default => "localhost"
