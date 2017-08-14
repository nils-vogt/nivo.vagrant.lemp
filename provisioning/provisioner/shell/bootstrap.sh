#! /usr/bin/env bash

set -o errexit # stop executing once a command fails

# prints a decorated section with passed message
function echoSection {
	echo " "
	echo '---------------------------------------------------------------'
	echo '// '${1^^}
	echo '==============================================================='
}

sudo su

# apply apt-get update
#
echoSection "> apply apt-get update..."
apt-get -y update >/dev/null

# install dos2unix
#
echoSection "> installing dos2unix..."
apt-get install -y dos2unix >/dev/null

# include config
#
dos2unix /home/vagrant/code/provisioning/provisioner/shell/config.sh #get rid of messed up line-endings
source /home/vagrant/code/provisioning/provisioner/shell/config.sh

# install curl
#
echoSection "> installing common tools..."
apt-get install -y curl zip unzip >/dev/null

# add repository ppa:ondrej/php in order to install php7
#
echoSection "> adding repository ppa:ondrej/php..."
apt-get install software-properties-common >/dev/null
add-apt-repository -y ppa:ondrej/php >/dev/null
apt-get update >/dev/null

# install server (nginx)
#
echoSection "> installing nginx..."
apt-get install -y nginx >/dev/null

# set nginx config
#
echoSection "> configuring nginx..."
rm /etc/nginx/sites-available/default
cp /home/vagrant/code/provisioning/resources/nginx.default /etc/nginx/sites-available/default

# link document root
#
if ! [ -L /usr/share/nginx/html ]; then
	rm -rf /usr/share/nginx/html
	ln -fs ${document_root} /usr/share/nginx/html
fi

# install php7 stack
#
echoSection "> installing php7 stack..."
apt-get install -y --force-yes php7.1-fpm php7.1 php7.1-mysql php7.1-curl php7.1-gd php7.1-intl php-pear php7.1-imap php7.1-mcrypt php7.1-sqlite3 php7.1-mbstring php7.1-bcmath snmp >/dev/null

# install xdebug
#
echoSection "> installing xdebug..."
apt-get install -y php7.1-dev >/dev/null
pecl install xdebug >/dev/null
bash -c "cat /home/vagrant/code/provisioning/resources/xdebug-php.ini >> /etc/php/7.1/fpm/php.ini"
bash -c "cat /home/vagrant/code/provisioning/resources/xdebug-php.ini >> /etc/php/7.1/cli/php.ini"

# install mysql-server (without prompt)
#
echoSection "> installing mysql-server..."
debconf-set-selections <<< 'mysql-server mysql-server/root_password password '${db_username} >/dev/null
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '${db_password} >/dev/null
apt-get -y install mysql-server-5.6 >/dev/null

# install mysql-client
#
echoSection "> installing mysql-client..."
apt-get install -y mysql-client-5.6 >/dev/null

# install phpunit
#
echoSection "> installing phpunit..."
wget https://phar.phpunit.de/phpunit.phar -nv
chmod +x phpunit.phar
mv phpunit.phar /usr/local/bin/phpunit

# install git
#
echoSection "> installing git..."
apt-get install -y git >/dev/null

# install composer
#
echoSection "> installing composer..."
curl -Ss https://getcomposer.org/installer | php >/dev/null
mv composer.phar /usr/local/bin/composer

# bootstrap the public root
#
echoSection "> preparing document root..."
if [ ! -d ${document_root} ];  then
	# create public root
	mkdir -p ${document_root}
	# place php info
	echo "<?php phpinfo(); ?>" >> ${document_root}/index.php
fi

# bootstrap the database
#
echoSection "> bootstrapping database..."
if [ -e /home/vagrant/code/provisioning/resources/bootstrap.sql ]; then
	cat /home/vagrant/code/provisioning/resources/bootstrap.sql | mysql -u ${db_username} --password=${db_password}
fi

# restart server
#
echoSection "> restarting php-fpm and nginx..."
service php7.0-fpm restart
service nginx restart
