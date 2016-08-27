name 'phantomjs2'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Installs/Configures phantomjs'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/dhoer/chef-phantomjs2' if respond_to?(:source_url)
issues_url 'https://github.com/dhoer/chef-phantomjs2/issues' if respond_to?(:issues_url)

version '1.1.0'

%w(centos debian fedora rhel ubuntu windows).each do |os|
  supports os
end
