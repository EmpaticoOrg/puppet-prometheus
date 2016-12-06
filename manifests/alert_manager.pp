# Class: prometheus::alert_manager
#
# This module manages prometheus alert_manager
#
# Parameters:
#
#  [*manage_user*]
#  Whether to create user for prometheus or rely on external code for that
#
#  [*user*]
#  User running prometheus
#
#  [*manage_group*]
#  Whether to create user for prometheus or rely on external code for that
#
#  [*purge_config_dir*]
#  Purge config files no longer generated by Puppet
#
#  [*group*]
#  Group under which prometheus is running
#
#  [*bin_dir*]
#  Directory where binaries are located
#
#  [*arch*]
#  Architecture (amd64 or i386)
#
#  [*version*]
#  Prometheus alert_manager release
#
#  [*install_method*]
#  Installation method: url or package (only url is supported currently)
#
#  [*os*]
#  Operating system (linux is the only one supported)
#
#  [*download_url*]
#  Complete URL corresponding to the Prometheus alert_manager release, default to undef
#
#  [*download_url_base*]
#  Base URL for prometheus alert_manager
#
#  [*download_extension*]
#  Extension of Prometheus alert_manager binaries archive
#
#  [*package_name*]
#  Prometheus alert_manager package name - not available yet
#
#  [*package_ensure*]
#  If package, then use this for package ensure default 'latest'
#
#  [*config_file*]
#  The configuration file for alert manager (it should be under $prometheus::config_dir directory, it depends on it)
#
#  [*extra_options*]
#  Extra options added to prometheus startup command
#
#  [*service_enable*]
#  Whether to enable or not prometheus alert_manager service from puppet (default true)
#
#  [*service_ensure*]
#  State ensured from prometheus alert_manager service (default 'running')
#
#  [*manage_service*]
#  Should puppet manage the prometheus alert_manager service? (default true)
#
#  [*restart_on_change*]
#  Should puppet restart prometheus alert_manager on configuration change? (default true)
#
#  [*init_style*]
#  Service startup scripts style (e.g. rc, upstart or systemd)
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class prometheus::alert_manager (
  $manage_user          = true,
  $user                 = $::prometheus::params::alert_manager_user,
  $manage_group         = true,
  $purge_config_dir     = true,
  $group                = $::prometheus::params::alert_manager_group,
  $bin_dir              = $::prometheus::params::bin_dir,
  $arch                 = $::prometheus::params::arch,
  $version              = $::prometheus::params::alert_manager_version,
  $install_method       = $::prometheus::params::install_method,
  $os                   = $::prometheus::params::os,
  $download_url         = undef,
  $download_url_base    = $::prometheus::params::alert_manager_download_url_base,
  $download_extension   = $::prometheus::params::alert_manager_download_extension,
  $package_name         = $::prometheus::params::alert_manager_package_name,
  $package_ensure       = $::prometheus::params::alert_manager_package_ensure,
  $storage_path         = $::prometheus::params::alert_manager_storage_path,
  $config_dir           = $::prometheus::params::alert_manager_config_dir,
  $config_file          = $::prometheus::params::alert_manager_config_file,
  $global               = $::prometheus::params::alert_manager_global,
  $route                = $::prometheus::params::alert_manager_route,
  $receivers            = $::prometheus::params::alert_manager_receivers,
  $templates            = $::prometheus::params::alert_manager_templates,
  $inhibit_rules        = $::prometheus::params::alert_manager_inhibit_rules,
  $extra_options        = '',
  $config_mode          = $::prometheus::params::config_mode,
  $service_enable       = true,
  $service_ensure       = 'running',
  $manage_service       = true,
  $restart_on_change    = true,
  $init_style           = $::prometheus::params::init_style,
) inherits prometheus::params {
  if( versioncmp($::prometheus::alert_manager::version, '0.3.0') == -1 ){
    $real_download_url    = pick($download_url,
      "${download_url_base}/download/${version}/${package_name}-${version}.${os}-${arch}.${download_extension}")
  } else {
    $real_download_url    = pick($download_url,
      "${download_url_base}/download/v${version}/${package_name}-${version}.${os}-${arch}.${download_extension}")
  }
  validate_bool($purge_config_dir)
  validate_bool($manage_user)
  validate_bool($manage_service)
  validate_bool($restart_on_change)
  validate_array($templates)
  validate_array($receivers)
  validate_array($inhibit_rules)
  validate_hash($global)
  validate_hash($route)
  $notify_service = $restart_on_change ? {
    true    => Service['alert_manager'],
    default => undef,
  }

  $options = "-config.file=${prometheus::alert_manager::config_file} -storage.path=${prometheus::alert_manager::storage_path} ${prometheus::alert_manager::extra_options}"

  file { $config_dir:
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    purge   => $purge,
    recurse => $purge,
  }

  file { $config_file:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => $config_mode,
    content => template('prometheus/alert_manager.yaml.erb'),
    require => File[$config_dir],
  }

  prometheus::daemon { 'alert_manager':
    install_method     => $install_method,
    version            => $version,
    download_extension => $download_extension,
    os                 => $os,
    arch               => $arch,
    real_download_url  => $real_download_url,
    bin_dir            => $bin_dir,
    notify_service     => $notify_service,
    package_name       => $package_name,
    package_ensure     => $package_ensure,
    manage_user        => $manage_user,
    user               => $user,
    extra_groups       => $extra_groups,
    group              => $group,
    manage_group       => $manage_group,
    purge              => $purge_config_dir,
    options            => $options,
    init_style         => $init_style,
    service_ensure     => $service_ensure,
    service_enable     => $service_enable,
    manage_service     => $manage_service,
  }
}
