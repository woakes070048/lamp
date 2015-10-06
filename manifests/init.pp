# Class: lamp
#
# This module manages lamp
#
# Parameters:
#
class lamp (
  $site_name     = $::lamp::params::site_name,
  $dir_lamp = $::lamp::params::dir_lamp,
  $url_source    = $::lamp::params::url_source,
  $owner         = $::lamp::params::owner,
  $group         = $::lamp::params::group) inherits ::lamp::params {
  # Begin
  include lamp::mysql
  include lamp::packages
  include ::apache
  include ::apache::php

  file { $dir_lamp:
    ensure => directory,
    mode   => '0755'
  } ->
  artifact { 'lamp.tar.gz':
    source => $url_source,
    target => $dir_lamp,
    rename => 'lamp.tar.gz',
  } ->
  exec { 'copy_move_chown_restor':
    path    => '/sbin:/bin:/usr/bin',
    command => "tar xfz ${dir_lamp}/lamp.tar.gz --strip-components=1 -C /var/www/html && chown -R apache:apache /var/www/html && restorecon -R /var/www/html",
    unless  => 'test -d /var/www/html/wp-admin'
  } ->
  apache::vhost { $site_name:
    port    => '80',
    docroot => '/var/www/html',
  }

}

