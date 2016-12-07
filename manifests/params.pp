# Class prometheus::params
# Include default parameters for prometheus class
class prometheus::params {
  $user = 'prometheus'
  $group = 'prometheus'
  $extra_groups = []
  $bin_dir = '/usr/local/bin'
  $config_dir = '/etc/prometheus'
  $localstorage = '/var/lib/prometheus'
  $shared_dir = '/usr/local/share/prometheus'
  $install_method = 'url'
  $package_ensure = 'latest'
  $package_name = 'prometheus'
  $download_url_base = 'https://github.com/prometheus/prometheus/releases'
  $version = '1.0.1'
  $download_extension = 'tar.gz'
  $node_exporter_download_url_base = 'https://github.com/prometheus/node_exporter/releases'
  $node_exporter_version = '0.13.0'
  $node_exporter_download_extension = 'tar.gz'
  $node_exporter_collectors = ['diskstats','filesystem','loadavg','meminfo','netdev','stat','time']
  $node_exporter_package_ensure = 'latest'
  $node_exporter_package_name = 'node_exporter'
  $node_exporter_extra_groups = []
  $node_exporter_user = 'node-exporter'
  $node_exporter_group = 'node-exporter'
  $statsd_exporter_download_url_base = 'https://github.com/prometheus/statsd_exporter/releases'
  $statsd_exporter_version = '0.3.0'
  $statsd_exporter_download_extension = 'tar.gz'
  $statsd_exporter_package_ensure = 'latest'
  $statsd_exporter_package_name = 'statsd_exporter'
  $statsd_exporter_extra_groups = []
  $statsd_exporter_user = 'statsd-exporter'
  $statsd_exporter_group = 'statsd-exporter'
  $statsd_exporter_mapping_config_path = '/etc/statsd_mappings.conf'
  $statsd_exporter_maps = [
    {
      'map' => 'test.dispatcher.*.*.*',
      'name' =>'dispatcher_events_total',
      'labels' =>
        {
          'processor'=>'$1',
          'action'=>'$2',
          'outcome'=>'$3',
          'job'=>'test_dispatcher',
        },
    },
  ]
<<<<<<< HEAD
  $alertmanager_download_url_base = 'https://github.com/prometheus/alertmanager/releases'
  $alertmanager_config_dir = '/etc/alertmanager'
  $alertmanager_config_file = "${alertmanager_config_dir}/alertmanager.yaml"
  $alertmanager_global = { 'smtp_smarthost' =>'localhost:25', 'smtp_from'=>'alertmanager@localhost' }
  $alertmanager_templates = [ "${alertmanager_config_dir}/*.tmpl" ]
  $alertmanager_route = { 'group_by'               =>  [ 'alertname', 'cluster', 'service' ], 'group_wait'=> '30s', 'group_interval'=> '5m', 'repeat_interval'=> '3h', 'receiver'=> 'Admin' }
  $alertmanager_receivers = [ { 'name'             => 'Admin', 'email_configs'=> [ { 'to'=> 'root@localhost' }] }]
  $alertmanager_inhibit_rules = [ { 'source_match' => { 'severity'=> 'critical' },'target_match'=> { 'severity'=>'warning'},'equal'=>['alertname','cluster','service']}]
  $alertmanager_storage_path='/var/lib/alertmanager'
  $alertmanager_version = '0.3.0'
  $alertmanager_download_extension = 'tar.gz'
  $alertmanager_package_ensure = 'latest'
  $alertmanager_package_name = 'alertmanager'
  $alertmanager_user = 'alertmanager'
  $alertmanager_group = 'alertmanager'
  $config_template = 'prometheus/prometheus.yaml.erb'
  $config_mode = '0660'
  $global_config = { 'scrape_interval'=> '15s', 'evaluation_interval'=> '15s', 'external_labels'=> { 'monitor'=>'master'}}
  $mysqld_exporter_cnf_config_path = '/etc/.my.cnf'
  $mysqld_exporter_cnf_user = 'login'
  $mysqld_exporter_cnf_password = 'password'
  $mysqld_exporter_cnf_host = 'localhost'
  $mysqld_exporter_cnf_port = 3306
  $mysqld_exporter_version = '0.9.0'
  $mysqld_exporter_extra_groups = []
  $mysqld_exporter_user = 'mysqld-exporter'
  $mysqld_exporter_group = 'mysqld-exporter'
  $mysqld_exporter_download_url_base = 'https://github.com/prometheus/mysqld_exporter/releases'
  $mysqld_exporter_download_extension = 'tar.gz'
  $mysqld_exporter_package_name = 'mysqld_exporter'
  $mysqld_exporter_package_ensure = 'latest'
  $config_mode = '0660'
  $global_config = { 'scrape_interval'=> '15s', 'evaluation_interval'=> '15s', 'external_labels'=> { 'monitor'=>'master'}}
  $rule_files = [ "${config_dir}/alert.rules" ]
  $scrape_configs = [ { 'job_name'=> 'prometheus', 'scrape_interval'=> '10s', 'scrape_timeout'=> '10s', 'static_configs'=> [ { 'targets'=> [ 'localhost:9090' ], 'labels'=> { 'alias'=> 'Prometheus'} } ] } ]
  case $::architecture {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386'   }
    default:           {
      fail("Unsupported kernel architecture: ${::architecture}")
    }
  }

  $os = downcase($::kernel)

  if $::operatingsystem == 'Ubuntu' {
    if versioncmp($::operatingsystemrelease, '8.04') < 1 {
      $init_style = 'debian'
    } elsif versioncmp($::operatingsystemrelease, '15.04') < 0 {
      $init_style = 'upstart'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem =~ /Scientific|CentOS|RedHat|OracleLinux/ {
    if versioncmp($::operatingsystemrelease, '7.0') < 0 {
      $init_style = 'sysv'
    } else {
      $init_style  = 'systemd'
    }
  } elsif $::operatingsystem == 'Fedora' {
    if versioncmp($::operatingsystemrelease, '12') < 0 {
      $init_style = 'sysv'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem == 'Debian' {
    if versioncmp($::operatingsystemrelease, '8.0') < 0 {
      $init_style = 'debian'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem == 'Archlinux' {
    $init_style = 'systemd'
  } elsif $::operatingsystem == 'OpenSuSE' {
    $init_style = 'systemd'
  } elsif $::operatingsystem =~ /SLE[SD]/ {
    if versioncmp($::operatingsystemrelease, '12.0') < 0 {
      $init_style = 'sles'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem == 'Darwin' {
    $init_style = 'launchd'
  } elsif $::operatingsystem == 'Amazon' {
    $init_style = 'sysv'
  } else {
    $init_style = undef
  }
  if $init_style == undef {
    fail('Unsupported OS')
  }
}
