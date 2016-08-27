use_inline_resources

def whyrun_supported?
  true
end

def version_installed?(executable)
  cmd = Mixlib::ShellOut.new("#{executable} --version")
  cmd.run_command
  cmd.error!
  cmd.stdout.chomp == new_resource.version
end

action :install do
  return Chef::Log.warn("Platform #{node['platform']} is not supported!") if platform?('mac_os_x', 'windows')

  directory new_resource.path do
    mode '0755'
    owner new_resource.user
    group new_resource.group
  end

  new_resource.packages.each { |name| package name } unless platform?('windows')

  executable = "#{new_resource.path}/#{new_resource.basename}/bin/phantomjs"

  remote_file "#{new_resource.path}/#{new_resource.basename}.tar.bz2" do
    owner new_resource.user
    group new_resource.group
    mode '0644'
    backup false
    source "#{new_resource.base_url}/#{new_resource.basename}.tar.bz2"
    checksum new_resource.checksum if new_resource.checksum
    not_if { ::File.exist?(executable) && version_installed?(executable) }
    notifies :run, 'execute[phantomjs-install]', :immediately unless platform?('windows')
  end

  execute 'phantomjs-install' do
    command "tar -xvjf #{new_resource.path}/#{new_resource.basename}.tar.bz2"
    cwd new_resource.path
    action :nothing
    notifies :create, "link[phantomjs-link #{executable}]", :immediately
  end

  link "phantomjs-link #{executable}" do
    target_file '/usr/local/bin/phantomjs'
    to executable
    owner new_resource.user
    group new_resource.group
    action :nothing
    only_if { new_resource.link }
  end
end
