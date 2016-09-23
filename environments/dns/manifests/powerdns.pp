# include apt
#
# package { 'pdns-server':
#   ensure  => 'latest'
# }
#
class { '::powerdns':
  settings  => {
    'webserver'  => 'yes',
    'webserver-port' => '8080',
    'api'         => 'yes',
    'api-key'     => 'ring',
    'webserver-password' => 'ring',
    'allow-dnsupdate-from' => '192.168.0.0/16',
  },
  package_ensure  => 'latest',
}

class { '::powerdns::backend::gmysql':
  host      => '192.168.10.3',
  user      => 'isildur',
  password  => 'IhIN60Vih2xeew',
  dbname    => 'powerdns',
}

# powerdns::config { 'launch':
#   ensure  => present,
#   setting => 'launch',
#   value   => 'gmysql',
# }

# powerdns::config { 'web-server':
#   ensure  => present,
#   setting => 'web-server',
#   value   => 'yes',
# }
#
# powerdns::config { 'api':
#   ensure  => present,
#   setting => 'api',
#   value   => 'yes',
# }
#
# powerdns::config { 'dnsupdate':
#   ensure  => present,
#   setting => 'allow-dnsupdate-from',
#   value   => '192.168.0.0/16',
# }
