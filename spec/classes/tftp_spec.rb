require 'spec_helper'
describe 'tftp', :type => :class do

  describe 'when deploying on debian' do
    let(:facts) { { :operatingsystem => 'Debian',
                    :path            => '/usr/local/bin:/usr/bin:/bin', } }

    it { should contain_file('/etc/default/tftpd-hpa') }
    it { should contain_package('tftpd-hpa') }
    it { should contain_service('tftpd-hpa').with({
      'ensure'    => 'running',
      'enable'    => true,
      'hasstatus' => false,
      'provider'  => nil,
    }) }
  end

  describe 'when deploying on ubuntu' do
    let(:facts) { { :operatingsystem => 'Ubuntu',
                    :path            => '/usr/local/bin:/usr/bin:/bin', } }

    it { should contain_package('tftpd-hpa') }
    it { should contain_file('/etc/default/tftpd-hpa') }
    it { should contain_service('tftpd-hpa').with({
      'ensure'    => 'running',
      'enable'    => true,
      'hasstatus' => true,
      'provider'  => 'upstart',
    }) }
  end

  describe 'when deploying with inetd' do
    let(:facts) { { :operatingsystem => 'Debian',
                    :path            => '/usr/local/bin:/usr/bin:/bin', } }
    let(:params) { { :inetd => true, } }

    it { should contain_package('tftpd-hpa') }
    it { should contain_file('/etc/default/tftpd-hpa') }
    it { should contain_class('inetd') }
    it { should contain_augeas('inetd_tftp').with({
      'changes' => [
        "ins tftp after /files/etc/inetd.conf",
        "set /files/etc/inetd.conf/tftp/socket dgram",
        "set /files/etc/inetd.conf/tftp/protocol udp",
        "set /files/etc/inetd.conf/tftp/wait wait",
        "set /files/etc/inetd.conf/tftp/user tftp",
        "set /files/etc/inetd.conf/tftp/command /usr/libexec/tftpd",
        "set /files/etc/inetd.conf/tftp/arguments/1 tftpd",
        "set /files/etc/inetd.conf/tftp/arguments/2 --address",
        "set /files/etc/inetd.conf/tftp/arguments/3 0.0.0.0:69",
        "set /files/etc/inetd.conf/tftp/arguments/4 --secure",
        "set /files/etc/inetd.conf/tftp/arguments/5 /srv/tftp",
      ],
    }) }
    it { should contain_service('tftpd-hpa').with({
      'ensure'    => 'stopped',
      'enable'    => false,
      'hasstatus' => false,
      'provider'  => nil,
    }) }
  end

  describe 'when deploying with inetd and custom options' do
    let(:facts) { { :operatingsystem => 'Debian',
                    :path            => '/usr/local/bin:/usr/bin:/bin', } }
    let(:params) { { :inetd          => true,
                     :options        => '--timeout 5 --secure', } }

   it { expect { should contain_class('tftp') }.to raise_error(Puppet::Error) }
  end
end
