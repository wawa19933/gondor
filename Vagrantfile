# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  servers = {
    'minas-tirith'  => '192.168.10.1',  # Firewall
    'osgiliath'     => '192.168.10.2',  # DNS
    'linhir'        => '192.168.10.3',  # MySQL
    'ethring'       => '192.168.10.254',# DHCP
  }

  servers.each do |server_name, server_ip|
    config.vm.define server_name do |host|
      host.vm.box = "bento/ubuntu-16.04"
      host.vm.hostname = "#{server_name.to_s}"
      # host.vm.network :private_network, ip: "#{server_ip}"
      host.vm.synced_folder ".", "/vagrant", :type => "nfs"

      # For KVM
      host.vm.provider :libvirt do |l, override|
        override.vm.network :public_network, ip: "#{server_ip}",
          # :dev => "vme",
          # :ovs => true,
          # :mode => "bridge",
          :type => "network",
          :network_name => "vme-network",
          :portgroup => "vlan-10"

        l.memory = 512
        l.cpus = 1
        # l.storage :file, :device => :cdrom, :path => "/home/smaximov/images/cloud-init.iso"
      end # libvirt config

      host.vm.provision :shell, :path => "environments/init.sh"

    end # Guest definition
  end # Servers list

  #
  # Linhir definition (MySQL)
  #
  config.vm.define "linhir" do |linhir|
    # linhir.vm.synced_folder "mysql", "/vagrant/mysql", :type => "rsync"
    # linhir.vm.provision :ansible do |ansible|
    #   ansible.playbook = "provision/mariadb.yml"
    # end

    linhir.vm.provision :puppet do |puppet|
      # puppet.binary_path = "/opt/puppetlabs/bin"
      puppet.module_path = "/home/smaximov/.puppet/modules"
      puppet.environment = "mysql"
      puppet.environment_path = "environments"
      puppet.hiera_config_path = "hiera.yaml"
      puppet.synced_folder_type = "nfs"
      # puppet.manifest_file = "mysql.pp"
      # puppet.manifests_path = "provision"
      # puppet.options = "--verbose --debug"
    end
    # linhir.vm.provision :shell, inline: <<-SHELL
# mkdir /var/lib/mysql
# mysql -uroot -p
# SHELL
    # linh.vm.provision :docker, images: [ "docker.io/mariadb:latest" ]
  end

  #
  # Ethring definition (DHCP)
  #
  config.vm.define "ethring" do |ethring|
  end

  #
  # Osgiliath detalies (DNS)
  #
  config.vm.define "osgiliath" do |osgiliath|
    # osgiliath.vm.synced_folder "dnsd/pdns", "/etc/pdns", :type => 'nfs'
    osgiliath.vm.provision :puppet do |puppet|
      puppet.module_path = "/home/smaximov/.puppet/modules"
      puppet.environment = "dns"
      puppet.environment_path = "environments"
      puppet.hiera_config_path = "hiera.yaml"
      puppet.synced_folder_type = "nfs"
    end
  end

  #
  # Minas-Tirith provision (Firewall)
  #
  config.vm.define "minas-tirith" do |mt|
    mt.vm.provision :puppet do |puppet|
      puppet.module_path = "/home/smaximov/.puppet/modules"
      puppet.environment = "monitor"
      puppet.environment_path = "environments"
      puppet.hiera_config_path = "hiera.yaml"
      puppet.synced_folder_type = "nfs"
    end
    # mt.vm.synced_folder "dhcpd/conf/kea", "/etc/kea", :type => "rsync"
    # mt.vm.provision :docker, images: [ "wawa19933/kea-dhcp" ]
  end

  #
  # Docker containers definition
  #
  # config.vm.define "dhcpd" do |dhcp_server|
  #   dhcp_server.vm.provider :docker do |d|
  #     d.vagrant_vagrantfile = "Vagrantfile"
  #     d.vagrant_machine = "minas-tirith"
  #     d.image = "wawa19933/kea-dhcp"
  #     d.name = "dhcp"
  #     d.volumes = [ "/etc/kea:/etc/kea:Z" ]
  #     d.create_args = [ "--net", "host", "--privileged=true" ]
  #     d.remains_running = true
  #   end
  # end

  # config.vm.define "mysql" do |db|
  #   db.vm.provider :docker do |d|
  #     d.vagrant_vagrantfile = "Vagrantfile"
  #     d.vagrant_machine = "osgiliath"
  #     d.image = "docker.io/mariadb:latest"
  #     d.name = "mysql"
  #     d.env = { :MYSQL_ROOT_PASSWORD => "dye4rfahjcz", :MYSQL_DATABASE => "dhcp", :MYSQL_USER => "kea", :MYSQL_PASSWORD => "Xmw2jUBsreOXVbu25w" }
  #     d.volumes = [ "/var/lib/mysql:/var/lib/mysql:Z", "/etc/mysql/conf.d:/etc/mysql/conf.d:Z" ]
  #     d.ports = [ "3306:3306" ]
  #     d.remains_running = true
  #     # d.create_args =
  #   end
  # end

end # Vagrant config
