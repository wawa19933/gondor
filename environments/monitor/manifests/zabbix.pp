
class { 'apache':
  mpm_module => 'prefork',
}

class { 'apache::mod::php': }

class { 'zabbix::web':
  zabbix_url  => 'eye.middle-earth.dev/zabbix',
  zabbix_server => 'eye.middle-earth.dev',
  database_host => 'linhir.middle-earth.dev',
  database_type => 'mysql',
  zabbix_version => '3.2',
}

class { 'zabbix::server':
  database_host => 'linhir.middle-earth.dev',
  database_type => 'mysql',
  zabbix_version => '3.2',
}

class { '::mysql::client':
  package_name    => 'mariadb-client-10.0',
  package_ensure  => 'latest',
}

# class { 'mysql::bindings':
#   php_enable  => true,
#   php_package_name  => 'php7.0-mysql',
# }
