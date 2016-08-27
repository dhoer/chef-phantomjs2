require 'spec_helper'

describe 'phantomjs2::default' do
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
    expect(resource).to notify('execute[tar -xvjf /src/phantomjs-1.0.0-linux-x86_64.tar.bz2]').to(:run).immediately
  end

  it 'extracts the binary' do
    expect(chef_run).to_not run_execute('tar -xvjf /src/phantomjs-1.0.0-linux-x86_64.tar.bz2')
  end

  it 'notifies the link' do
    resource = chef_run.execute('tar -xvjf /src/phantomjs-1.0.0-linux-x86_64.tar.bz2')
    expect(resource).to notify(
      'link[phantomjs-link /src/phantomjs-1.0.0-linux-x86_64/bin/phantomjs]'
    ).to(:create).immediately
  end

  it 'creates the symlink' do
    expect(chef_run).to_not create_link('phantomjs-link /src/phantomjs-1.0.0-linux-x86_64/bin/phantomjs')
  end
end
