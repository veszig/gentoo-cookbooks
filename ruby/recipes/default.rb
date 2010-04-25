# ruby --enable-pthread is evil
gentoo_package "dev-lang/ruby" do
  use "-threads"
end
