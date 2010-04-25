def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @action = :install
end

actions :install, :upgrade, :remove, :purge, :reinstall

attribute :version,       :kind_of => String
attribute :options,       :kind_of => String
attribute :use,           :kind_of => [ String, Array ]
attribute :keywords,      :kind_of => String
attribute :mask,          :kind_of => String
attribute :unmask,        :kind_of => String
