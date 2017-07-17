# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  #config.vm.provision :shell, path: "provisioning/shell/bootstrap.sh", keep_color: true
  config.vm.provision :puppet, manifests_path: "provisioning/puppet/environments/development/manifests", module_path: "provisioning/puppet/modules"
  config.vm.network "forwarded_port", guest: 80,    host: 8082
  config.vm.network "forwarded_port", guest: 3306,  host: 33306
  config.vm.network "private_network", ip: "111.111.11.11"
  config.vm.synced_folder './', '/home/vagrant/code', nfs: true
  config.vm.provider "virtualbox" do |v|
    v.gui = false
    v.customize ["modifyvm", :id, "--memory", "1024"]
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "95"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  config.vm.provision "puppet" do |puppet|
    puppet.facter = {
      'fqdn'             => "foo",
    }
    puppet.manifests_path = "provisioning/puppet/environments/development/manifests"
  end
end
