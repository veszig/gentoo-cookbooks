def initialize(name, run_context=nil)
  super(name, run_context)
  @action = :install
end

actions :install, :upgrade, :remove, :purge, :reinstall

attribute :version,       :kind_of => String
attribute :options,       :kind_of => String
attribute :use,           :kind_of => [ String, Array ]
attribute :keywords,      :kind_of => String
attribute :mask,          :kind_of => String
attribute :unmask,        :kind_of => String
