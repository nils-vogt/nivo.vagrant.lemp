# see https://docs.puppet.com/puppet/latest/type.html for documentation of
# available recource type documentation

# update apt
exec { 'apt-get update':
  path => '/usr/bin', # The search path used for command execution
}

# install php7
exec { 'php-repo':
  #  The actual command to execute.
  command => 'sudo apt-get install -y software-properties-common>/dev/null && sudo add-apt-repository -y ppa:ondrej/php>/dev/null && sudo apt-get update>/dev/null',
  path => '/usr/bin',
}

$php7packages = [
  'php7.0-fpm', 'php7.0', 'php7.0-mysql',
  'php7.0-curl', 'php7.0-gd', 'php7.0-intl',
  'php-pear', 'php7.0-imap', 'php7.0-mcrypt',
  'php7.0-sqlite3', 'php7.0-mbstring', 'php7.0-bcmath', 'snmp'
]

package { $php7packages: # install multiple packages at once
  ensure  => present, # present aka installed|absent|purged|held|latest
  require => Exec['php-repo'], # One or more resources that this resource depends on
}

# install and run nginx
package { 'nginx':
  ensure  => present, # Whether the file should exist (present|absent|file|directory|link)
  require => Exec['apt-get update'],
}

service { 'nginx':
  ensure  => 'running', # stopped aka false | running aka true.
  require => Package['nginx'],
}

# link shipped nginx-config
file { '/etc/nginx/sites-available/default':
  ensure  => 'link', # present|absent|file|directory|link.
  target  => '/home/vagrant/code/provisioning/resources/nginx.default', # symlink target
  require => Package['nginx'],
  # If Puppet makes changes to this resource, it will cause all of the notified resources to refresh. (Refresh behavior varies by resource type: services will restart, mounts will unmount and re-mount, etc. Not all types can refresh.)
  notify  => Service['nginx'],
}

# create the app directory
file { 'application directory':
  path => '/home/vagrant/code/app',
  ensure  => 'directory',
  require => Package['nginx'],
  force => true,
}

# prepare the document root
file { 'document root directory':
  path => '/home/vagrant/code/app/public',
  ensure  => 'directory',
  require => File['application directory'],
  force => true,
}

# create the index.php
file { 'document root index':
  path => '/home/vagrant/code/app/public/index.php',
  ensure  => 'file',
  require => File['document root directory'],
  content => '<?php phpinfo(); ?>',
  force => true,
}

# link the document root
file { '/usr/share/nginx/html':
  ensure  => 'link',
  target  => '/home/vagrant/code/app/public',
  require => [Package['nginx'], File['document root index']],
  force => true,
}

