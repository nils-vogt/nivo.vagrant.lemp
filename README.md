# LEMP stack on a virtual machine using Vagrant

This is how I set up a LEMP-Stack on a virtual machine for sandboxed projects. The Vagrantfile comes with a bootstrap.sh setting up everything you need on a virtual machine. Feel free to customize the bootstrapping to fit your needs.

## The setup installs and configures the tools below on a virtual ubuntu machine

- curl, zip, unzip
- nginx
- php7
- mysql
- xdebug
- phpunit
- git
- composer

Once the environment was successfully set up, the `bootstrap.sql` placed in `provisioning/resources` will be processed against mysql so thats a handy place to put a database dump in. Anyway, since this is optional you simply can remove this file if you do not need it.

# Setup

## customize the bootstrapping for provisioner shell (optional)
You can customize the bootstrap configuration in `provisioning/provisioner/shell/config.sh` if the defaults do not match your requirements:

assign the root directory of your server:
> document_root="/home/vagrant/code/app/public"

set the database user:
> db_username="root"

set the database pass:
> db_password="root"

## create an entry in your hosts file (optional)

> 111.111.11.11	dev.local

run `vagrant up`

The vagrant box is now setting up the environment with the ip *111.111.11.11*
If not found the bootstrap.sh creates the public root for your application:

> app/public

and places an index.php outputting `phpinfo()` to demonstrate php is up and running.

# Connect with HeidiSQL

Settings
---------
- Type: `MySQL (SSH tunnel)`
- Hostname/IP: `localhost`
- User: `root`
- Pass: `root`
- Port: `3306`

SSH Tunnel
----------
- plink.exe :selected
- SSH Host: `111.111.11.11`
- Port: `0`
- User: `vagrant`
- Pass: `vagrant`

# Debug with PHPStorm and XDebug

- "select run/Debug configuration"
- "edit configuration"
- (+) "PHP Remote Debgug"
- "IDE-KEY": `PHPSTORM`
- Server Configuration:
  - `127.0.0.1:8080`
  - XDebug
  - map "Project files" root to "/vagrant"

Start debugging session in PHPStorm and your browser


# The MIT License (MIT)

Copyright (c) 2014-2016 Nils Vogt, nilsvogt.de

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
