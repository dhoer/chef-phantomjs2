actions :install
default_action :install

attribute :path, kind_of: String, name_attribute: true
attribute :version, kind_of: String, default: lazy { node['phantomjs2']['version'] }
attribute :checksum, kind_of: [String, NilClass], default: lazy { node['phantomjs2']['checksum'] }
attribute :packages, kind_of: Array, default: lazy { node['phantomjs2']['packages'] }
attribute :base_url, kind_of: String, default: lazy { node['phantomjs2']['base_url'] }
attribute :basename, kind_of: String, default: lazy {
  platform?('windows') ? "phantomjs-#{version}-windows" : "phantomjs-#{version}-linux-#{node['kernel']['machine']}"
}
attribute :link, kind_of: [TrueClass, FalseClass], default: true
attribute :user, kind_of: String, default: 'root'
attribute :group, kind_of: String, default: 'root'
