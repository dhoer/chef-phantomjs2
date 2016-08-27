default['phantomjs2']['version'] = '2.1.1'
default['phantomjs2']['base_url'] = 'https://bitbucket.org/ariya/phantomjs/downloads'
default['phantomjs2']['checksum'] = nil
default['phantomjs2']['path'] = platform?('windows') ? "#{ENV['ProgramData']}/phantomjs" : '/usr/local/src'

case node['platform_family']
when 'debian'
  default['phantomjs2']['packages'] = %w(fontconfig libfreetype6 bzip2)
when 'gentoo'
  default['phantomjs2']['packages'] = ['media-libs/fontconfig', 'media-libs/freetype']
when 'rhel', 'fedora'
  default['phantomjs2']['packages'] = %w(fontconfig freetype bzip2)
else
  default['phantomjs2']['packages'] = []
end
