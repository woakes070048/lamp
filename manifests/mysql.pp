# class lamp::mysql
class lamp::mysql (
  $mysql_db   = $::lamp::params::mysql_host,
  $mysql_host = $::lamp::params::mysql_host,
  $mysql_user = $::lamp::params::mysql_user,
  $mysql_pass = $::lamp::params::mysql_pass,
  $mysql_root = $::lamp::params::mysql_root,) inherits ::lamp::params {
  # Setup MySQL
#  class { '::mysql::server':
#    root_password           => $mysql_root,
#    remove_default_accounts => true,
#  } ->
  
class { '::mysql::client':
  package_ensure        => 10.0,
  package_name          => mariadb,
  #install_option        =>
  
 } ->
  
  
  mysql_database { "${mysql_host}/${mysql_db}":
    name    => $mysql_db,
    charset => 'utf8',
  } ->
  mysql_user { "${mysql_user}@${mysql_host}": password_hash => mysql_password($mysql_pass), } ->
  mysql_grant { "${mysql_user}@${mysql_host}/${mysql_db}.*":
    table      => "${mysql_db}.*",
    user       => "${mysql_user}@${mysql_host}",
    privileges => ['ALL'],
  }

}