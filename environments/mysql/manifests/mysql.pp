include apt

package { 'python-software-properties':
  ensure => 'latest',
}

package { 'software-properties-common':
  ensure => 'latest',
}

file { "/tmp/powerdns.sql":
  ensure => present,
  source => "file:///vagrant/environments/mysql/powerdns.sql",
  # before => Class['::mysql::server']
}

package { 'mysql-old':
  ensure => 'purged',
  name   => 'mysql-server',
  before => Class['::mysql::server'],
}

package { 'mysql-cl':
  ensure => 'purged',
  name  => 'mysql-client',
  before => Class['::mysql::client'],
}

# exec { 'clean-mysql':
#   command => '/bin/rm -rf /etc/mysql',
#   before => Class['::mysql::server'],
# }
#
# MySQL (MariaDB)
#
class { '::mysql::client':
  package_name    => 'mariadb-client-10.0',
  package_ensure  => 'latest',
  # bindings_enable => true,
}

class { '::mysql::server':
  package_name    => 'mariadb-server-10.0',
  package_ensure  => installed,
  service_name    => 'mysql',
  root_password   => 'ring',
  config_file     => '/etc/mysql/mariadb.cnf',
  includedir      => '/etc/mysql/mariadb.conf.d',
  remove_default_accounts => true,
  service_provider  => 'systemd',
  purge_conf_dir  => false,
  override_options => {
    mysqld => {
      'bind-address'  => '::',
      'log-error' => '/var/log/mysql/mariadb.log',
      'pid-file'  => '/var/run/mysqld/mysqld.pid',
    },
    mysqld_safe => {
      'log-error' => '/var/log/mysql/mariadb.log',
    },
  },
  restart => true,
}

mysql::db { 'powerdns':
  user     => 'isildur',
  password => 'IhIN60Vih2xeew',
  host     => '192.168.10.%',
  grant    => ["ALL"],
  sql      => "/tmp/powerdns.sql"
}

mysql::db { 'dhcp_leases':
  user     => 'anarion',
  password => 'Xmw2jUBsreOXVbu25w',
  host     => '192.168.10.%',
  grant    => ["ALL"],
}

mysql::db { 'dhcp_hosts':
  user     => 'anarion',
  password => 'Xmw2jUBsreOXVbu25w',
  host     => '192.168.10.%',
  grant    => ["ALL"],
}

class { 'mysql::bindings':
  php_enable  => true,
  php_package_name  => 'php7.0-mysql',
}

class { 'zabbix::database':
  database_type => 'mysql',
  zabbix_web_ip => '192.168.10.3',
  zabbix_server_ip => '192.168.10.3',
  # zabbix_version => '3.2',
}

#
# Adminer PHP script
#

include wget

wget::fetch { "get_adminer":
  source => "https://www.adminer.org/latest-en.php",
  destination => "/var/www/html/adminer.php",
}

file { "/var/www/html/adminer.php":
  owner => 'root',
  group => 'www-data',
  mode => '0770',
}


#
# Apache2
#

class {'apache':
  purge_configs => false,
  default_vhost => false,
  mpm_module    => 'prefork',
}

apache::vhost { '192.168.10.3':
  priority        => 10,
  port            => '80',
  docroot         => '/var/www/html',
  rewrites => [
    {
      rewrite_rule => ['^/$ /adminer.php [NE,L,R=301]'],
    },
  ],
}

apache::vhost { 'linhir.middle-earth.dev':
  priority        => 5,
  port            => '80',
  docroot         => '/var/www/html',
  rewrites => [
    {
      rewrite_rule => ['^/$ /adminer.php [NE,L,R=301]'],
    },
  ],
}

class {'::apache::mod::php': }


#
# PHP
#
class { '::php::globals':
  php_version => '7.0',
}->
class { '::php':
  ensure       => 'latest',
  manage_repos => true,
  fpm          => false,
  dev          => true,
  composer     => true,
  pear         => true,
  phpunit      => false,
  settings   => {
    'PHP/max_execution_time'  => '90',
    'PHP/max_input_time'      => '300',
    'PHP/memory_limit'        => '64M',
    'PHP/post_max_size'       => '32M',
    'PHP/upload_max_filesize' => '32M',
    'Date/date.timezone'      => 'Europe/Berlin',
    'display_errors'          => 'On',
  },
}
