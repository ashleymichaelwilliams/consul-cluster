# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos/7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Vault Ports
  config.vm.network "forwarded_port", guest: 18200, host: 18200, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 28200, host: 28200, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 38200, host: 38200, host_ip: "127.0.0.1"

  # Consul Ports
  config.vm.network "forwarded_port", guest: 18500, host: 18500, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 28500, host: 28500, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 38500, host: 38500, host_ip: "127.0.0.1"


  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

  config.vm.provision "shell", inline: <<-SHELL

  # Download Dependencies
  sudo yum install -y epel-release
  sudo yum install -y jq git
  
  
  # Download/Install Docker
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2
  
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  
  sudo yum install -y docker-ce docker-ce-cli containerd.io
  
  sudo systemctl enable docker.service
  sudo systemctl start docker.service
  
  
  # Clone Repository
  git clone https://github.com/ashleymichaelwilliams/consul-cluster.git /consul-cluster
  
  SHELL
end
