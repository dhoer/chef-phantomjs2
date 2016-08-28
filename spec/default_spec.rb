require 'spec_helper'

describe 'phantomjs2::default' do
  context 'linux' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0', step_into: ['phantomjs2']) do |node|
        node.override['phantomjs2']['version'] = '1.0.0'
        node.override['phantomjs2']['path'] = '/src'
      end.converge(described_recipe)
    end

    it 'steps into phantomjs2 resource' do
      expect(chef_run).to install_phantomjs2('/src')
    end

    it 'creates install directory' do
      expect(chef_run).to create_directory('/src')
    end

    it 'installs packages' do
      expect(chef_run).to install_package('fontconfig')
      expect(chef_run).to install_package('freetype')
      expect(chef_run).to install_package('bzip2')
    end

    it 'downloads the tarball' do
      expect(chef_run).to create_remote_file('/src/phantomjs-1.0.0-linux-x86_64.tar.bz2').with(
        owner: 'root',
        group: 'root',
        mode: '0644'
      )
    end

    it 'notifies the execute resource' do
      resource = chef_run.remote_file('/src/phantomjs-1.0.0-linux-x86_64.tar.bz2')
      expect(resource).to notify('execute[untar phantomjs-1.0.0-linux-x86_64.tar.bz2]').to(:run).immediately
    end

    it 'extracts the binary' do
      expect(chef_run).to_not run_execute('tar -xvjf /src/phantomjs-1.0.0-linux-x86_64.tar.bz2')
    end

    it 'creates the symlink' do
      expect(chef_run).to create_link('phantomjs-link /src/phantomjs-1.0.0-linux-x86_64/bin/phantomjs')
    end
  end

  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2', step_into: 'phantomjs2') do |node|
        node.override['phantomjs2']['version'] = '2.0.0'
        ENV['ProgramData'] = 'C:\ProgramData'
      end.converge(described_recipe)
    end

    it 'steps into phantomjs2 resource' do
      expect(chef_run).to install_phantomjs2('C:\ProgramData/phantomjs')
    end

    it 'creates install directory' do
      expect(chef_run).to create_directory('C:\ProgramData/phantomjs')
    end

    it 'downloads the zip file' do
      expect(chef_run).to create_remote_file('C:\ProgramData/phantomjs/phantomjs-2.0.0-windows.zip').with(
        source: 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.0.0-windows.zip'
      )
    end

    it 'notifies the execute resource' do
      resource = chef_run.remote_file('C:\ProgramData/phantomjs/phantomjs-2.0.0-windows.zip')
      expect(resource).to notify('powershell_script[unzip phantomjs-2.0.0-windows.zip]').to(:run).immediately
    end

    it 'extracts the binary' do
      expect(chef_run).to_not run_powershell_script('unzip phantomjs-2.0.0-windows.zip')
    end

    it 'creates the symlink' do
      expect(chef_run).to create_link('phantomjs-link C:\ProgramData/phantomjs/phantomjs-2.0.0-windows')
    end

    it 'creates phantomjs environment variable' do
      expect(chef_run).to create_env('PHANTOMJS_HOME').with(
        value: 'C:\ProgramData/phantomjs/phantomjs'
      )
    end

    it 'adds phantomjs environment variable to pah' do
      expect(chef_run).to modify_env('PATH').with(
        value: '%PHANTOMJS_HOME%/bin'
      )
    end
  end
end
