# PhantomJS 2 Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/phantomjs2.svg?style=flat-square)][cookbook]
[![linux](http://img.shields.io/travis/dhoer/chef-phantomjs2/master.svg?label=linux&style=flat-square)][linux]
[![win](https://img.shields.io/appveyor/ci/dhoer/chef-phantomjs2/master.svg?label=windows&style=flat-square)][win]

[cookbook]: https://supermarket.chef.io/cookbooks/phantomjs2
[linux]: https://travis-ci.org/dhoer/chef-phantomjs2
[win]: https://ci.appveyor.com/project/dhoer/chef-phantomjs2

Installs the phantomjs cookbook and necessary packages. 
This is a fork from https://github.com/customink-webops/phantomjs with support for package installs removed.
This also adds a resource to install as many versions of phantomjs as your heart desires.

## Requirements

- Chef 12+

### Platforms

- CentOS, RedHat, Fedora 
- Debian, Ubuntu

## Usage
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

## Attributes

- `node['phantomjs2']['path']` - Location for the download. Default `/usr/local/src`.
- `node['phantomjs2']['version']` - The version to install. Default `1.9.8`.
- `node['phantomjs2']['checksum']` - The checksum of the download. Default `nil`.
- `node['phantomjs2']['base_url']` - URL for download. Default `https://bitbucket.org/ariya/phantomjs/downloads`.
- `node['phantomjs2']['packages']` - The supporting packages. Default varies based on platform.

## ChefSpec Matchers

This cookbook includes custom [ChefSpec](https://github.com/sethvargo/chefspec) matchers you can use to test 
your own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to install_phantomjs2('/src').with(
  version: "1.9.8"
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
