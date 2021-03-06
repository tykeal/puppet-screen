require 'spec_helper'

describe 'screen', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_anchor('screen::begin') }
      it { is_expected.to contain_class('screen::params') }
      it { is_expected.to contain_class('screen::install') }
      it { is_expected.to contain_class('screen::config') }
      it { is_expected.to contain_anchor('screen::end') }

      describe 'screen::install' do
        context 'defaults' do
          it do
            is_expected.to contain_package('screen').with(
              'ensure' => 'present'
            )
          end
        end

        context 'when package latest' do
          let(:params) do
            {
              package_ensure: 'latest'
            }
          end

          it do
            is_expected.to contain_package('screen').with(
              'ensure' => 'latest'
            )
          end
        end

        context 'when package absent' do
          let(:params) do
            {
              package_ensure: 'absent'
            }
          end

          it do
            is_expected.to contain_package('screen').with(
              'ensure' => 'absent'
            )
          end
          it do
            is_expected.to contain_file('screen.conf').with(
              'ensure'  => 'present',
              'require' => 'Package[screen]'
            )
          end
        end

        context 'when package purged' do
          let(:params) do
            {
              package_ensure: 'purged'
            }
          end

          it do
            is_expected.to contain_package('screen').with(
              'ensure' => 'purged'
            )
          end
          it do
            is_expected.to contain_file('screen.conf').with(
              'ensure'  => 'absent',
              'require' => 'Package[screen]'
            )
          end
        end
      end

      describe 'screen::config' do
        context 'defaults' do
          it do
            is_expected.to contain_file('screen.conf').with(
              'ensure'  => 'present',
              'require' => 'Package[screen]'
            )
          end
        end

        context 'when source dir' do
          let(:params) do
            {
              config_dir_source: 'puppet:///modules/screen/common/etc'
            }
          end

          it do
            is_expected.to contain_file('screen.dir').with(
              'ensure'  => 'directory',
              'force'   => false,
              'purge'   => false,
              'recurse' => true,
              'source'  => 'puppet:///modules/screen/common/etc',
              'require' => 'Package[screen]'
            )
          end
        end

        context 'when source dir purged' do
          let(:params) do
            {
              config_dir_purge: true,
              config_dir_source: 'puppet:///modules/screen/common/etc'
            }
          end

          it do
            is_expected.to contain_file('screen.dir').with(
              'ensure'  => 'directory',
              'force'   => true,
              'purge'   => true,
              'recurse' => true,
              'source'  => 'puppet:///modules/screen/common/etc',
              'require' => 'Package[screen]'
            )
          end
        end

        context 'when source file' do
          let(:params) do
            {
              config_file_source: 'puppet:///modules/screen/common/etc/screenrc'
            }
          end

          it do
            is_expected.to contain_file('screen.conf').with(
              'ensure'  => 'present',
              'source'  => 'puppet:///modules/screen/common/etc/screenrc',
              'require' => 'Package[screen]'
            )
          end
        end

        context 'when content string' do
          let(:params) do
            {
              config_file_string: '# THIS FILE IS MANAGED BY PUPPET'
            }
          end

          it do
            is_expected.to contain_file('screen.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'require' => 'Package[screen]'
            )
          end
        end
      end
    end
  end
end
