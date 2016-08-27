# PhantomJS2 Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/phantomjs2.svg?style=flat-square)][cookbook]
[![linux](http://img.shields.io/travis/dhoer/chef-phantomjs2/master.svg?label=linux&style=flat-square)][linux]
[![win](https://img.shields.io/appveyor/ci/dhoer/chef-phantomjs2/master.svg?label=windows&style=flat-square)][win]

[cookbook]: https://supermarket.chef.io/cookbooks/phantomjs2
[linux]: https://travis-ci.org/dhoer/chef-phantomjs2
[win]: https://ci.appveyor.com/project/dhoer/chef-phantomjs2

Installs phantomjs on both Linux and Windows. Windows path is set (unless link attribute is false) but requires you 
to reboot the server in order to have it available. So symlink path `#{node['phantomjs']['path']}/phantomjs`
is created and immediately available after Windows install.

## Requirements

- Chef 12+

### Platforms

- CentOS, RedHat, Fedora 
- Debian, Ubuntu
- Windows

# Usage

## Recipe
Add the cookbook to your `run_list` in a node or role:

```ruby
"run_list": [
  "recipe[phantomjs2::default]"
]
```

or include it in a recipe:

```ruby
# other_cookbook/metadata.rb
# ...
depends 'phantomjs2'
```
```ruby
# other_cookbook/recipes/default.rb
# ...
include_recipe 'phantomjs2::default'
```

### Attributes

- `node['phantomjs2']['path']` - Location for the download. Default Linux: `/usr/local/src` 
Windows: `#{ENV['ProgramData']}/phantomjs`.
- `node['phantomjs2']['version']` - The version to install. Default `2.1.1`.
- `node['phantomjs2']['checksum']` - The checksum of the download. Default `nil`.
- `node['phantomjs2']['base_url']` - The base URL to download from. 
Default `https://bitbucket.org/ariya/phantomjs/downloads`.
- `node['phantomjs2']['packages']` - The supporting packages. Default varies based on platform.

## Resource

### Actions

- Install - Download and install phantomjs

### Attributes

- `path` - Location for the download. Defaults to the name of the resource block.
- `version` - The version to install. Default `node['phantomjs2']['version']`.
- `checksum` - The checksum of the download. Defalt `node['phantomjs2']['checksum']`.
- `packages` - The supporting packages. Default `node['phantomjs2']['packages']`.
- `base_url` - The base URL to download from. Default `node['phantomjs2']['base_url']`.
- `basename` - The name of the file to download (this is automatically calculated from
the phantomjs version and kernel type). Default `phantomjs-#{version}-linux-#{node['kernel']['machine']}`.
- `link` - Link executable to path.  Note that Windows path is set (unless link is false) but requires you 
to reboot the server in order to have it available. Default `true`.
- `user` - The user name. Default `root`.
- `group` - The group name. Default `root`.

## ChefSpec Matchers

This cookbook includes custom [ChefSpec](https://github.com/sethvargo/chefspec) matchers you can use to test 
your own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to install_phantomjs2('/src').with(
  version: '1.9.8'
)
```
      
Cookbook Matchers

- install_phantomjs2(resource_name)

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/chef+phantomjs).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-phantomjs2/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-phantomjs2/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-phantomjs2/blob/master/LICENSE.md) file for details.
