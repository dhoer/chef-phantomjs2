require 'serverspec_helper'

describe 'nexus::default' do
  if os[:family] == 'windows'
    describe file('C:\ProgramData\phantomjs\phantomjs') do
      it { should exist }
    end

    describe command('C:\ProgramData\phantomjs\phantomjs\bin\phantomjs.exe -v') do
      its(:stdout) { should contain(/\d\.\d\.\d/) }
    end
  else
    describe file('/usr/local/bin/phantomjs') do
      it { should be_symlink }
    end

    describe command('phantomjs -v') do
      its(:stdout) { should contain(/\d\.\d\.\d/) }
    end
  end
end
