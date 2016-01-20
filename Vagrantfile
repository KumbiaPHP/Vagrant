# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "kumbia.vm"

  # Create a private network, which allows host-only access to the machine using a specific IP.
  config.vm.network "private_network", ip: "192.168.10.10"

  # Share an additional folder to the guest VM. The first argument is the path on the host to the actual folder.
  # The second argument is the path on the guest to mount the folder.
  config.vm.synced_folder "./kumbia", "/var/www/kumbia", create: true, group: "www-data", owner: "www-data"
  
  # Virtual Box specific config
  config.vm.provider "virtualbox" do |v|
   	v.name = "KumbiaPHP box for developers"
   	v.customize ["modifyvm", :id, "--memory", "512"]
    #v.customize ["modifyvm", :id, "--cpus", "2"]
    #v.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  
  # Setup port forwarding
  # MySql in local port 33066
  # config.vm.network "forwarded_port", guest: 3306, host: 33066, auto_correct: true
    
  # Define the bootstrap file: A (shell) script that runs after first setup of your box (= provisioning)
  config.vm.provision :shell, path: "shell/main.sh"

end
