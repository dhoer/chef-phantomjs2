if defined?(ChefSpec)
  def install_phantomjs2(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:phantomjs2, :install, resource_name)
  end
end
