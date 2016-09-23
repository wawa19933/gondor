class { 'icinga2':
  manage_repo => true,
  features    => ['checker', 'mainlog', 'notification', 'api',
                  'livestatus', 'perfdata', 'statusdata'],
}

class { 'icingaweb2':
  manage_apache_vhost => true,
  manage_repo    => true,
  install_method => 'package',
  initialize     => true,
  ido_db_host    => '192.168.10.3',
  # ido_db_name    => 'icinga2',
  ido_db_user    => 'valar',
  ido_db_pass    => 'ring',
  web_db_host    => '192.168.10.3',
  # web_db_name    => 'icingaweb2',
  web_db_user    => 'valar',
  web_db_pass    => 'ring',
}
