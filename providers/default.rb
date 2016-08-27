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
  return Chef::Log.warn("Platform #{node['platform']} is not supported!") if platform?('mac_os_x')

  directory new_resource.path do
    recursive true
    mode '0755' unless platform?('windows')
    owner new_resource.user unless platform?('windows')
    group new_resource.group unless platform?('windows')
  end

  new_resource.packages.each { |name| package name } unless platform?('windows')

  if platform?('windows')
    executable = "#{new_resource.path}/#{new_resource.basename}/phantomjs.exe"
  else
    executable = "#{new_resource.path}/#{new_resource.basename}/bin/phantomjs"
  end
  extension = platform?('windows') ? 'zip' : 'tar.bz2'
  download_path = "#{new_resource.path}/#{new_resource.basename}.#{extension}"

  remote_file download_path do
    owner new_resource.user unless platform?('windows')
    group new_resource.group unless platform?('windows')
    mode '0644' unless platform?('windows')
    backup false
    retries 300 # bitbucket can throw a lot of 403 Forbidden errors before finally downloading
    source "#{new_resource.base_url}/#{new_resource.basename}.#{extension}"
    checksum new_resource.checksum if new_resource.checksum
    not_if { ::File.exist?(executable) && version_installed?(executable) }
    notifies :run, "execute[untar #{new_resource.basename}.tar.bz2]", :immediately unless platform?('windows')
    notifies :run, "powershell_script[unzip #{new_resource.basename}.zip]", :immediately if platform?('windows')
  end

  if platform?('windows')
    powershell_script "unzip #{new_resource.basename}.zip" do
      code "Add-Type -A 'System.IO.Compression.FileSystem';" \
        " [IO.Compression.ZipFile]::ExtractToDirectory('#{download_path}', '#{new_resource.path}');"
      action :nothing
    end

    link "phantomjs-link #{new_resource.path}/#{new_resource.basename}" do
      target_file "#{new_resource.path}/phantomjs"
      to "#{new_resource.path}/#{new_resource.basename}"
      action :create
      only_if { new_resource.link }
    end

    env 'PHANTOMJS_HOME' do
      value "#{new_resource.path}/phantomjs"
      only_if { new_resource.link }
      action :create
    end

    # 2.x has bin directory but 1.x does not
    env 'PATH' do
      delim ::File::PATH_SEPARATOR
      value (new_resource.version.split('.')[0].to_i > 1) ? '%PHANTOMJS_HOME%/bin' : '%PHANTOMJS_HOME%'
      only_if { new_resource.link }
      action :modify
    end
  else
    execute "untar #{new_resource.basename}.tar.bz2" do
      command "tar -xvjf #{new_resource.path}/#{new_resource.basename}.tar.bz2"
      cwd new_resource.path
      action :nothing
    end

    link "phantomjs-link #{executable}" do
      target_file '/usr/local/bin/phantomjs'
      to executable
      owner new_resource.user
      group new_resource.group
      action :create
      only_if { new_resource.link }
    end
  end
end
