$script_hosts = <<-SCRIPT
echo '192.168.56.81 web' >> /etc/hosts
echo '192.168.56.82 bdd' >> /etc/hosts
echo '192.168.56.83 bastion' >> /etc/hosts
SCRIPT

Vagrant.configure("2") do |config|
  vm_configs = {
    "web"     => { ip: "192.168.56.81", script: "scripts/install_web.sh" },
    "bdd"     => { ip: "192.168.56.82", script: "scripts/install_bdd.sh" },
    "bastion" => { ip: "192.168.56.83", script: "scripts/install_bastion.sh" }
  }

  config.vm.box = "debian/bookworm64"

  vm_configs.each do |name, settings|
    config.vm.define name do |vm|
      vm.vm.hostname = name
      vm.vm.network :private_network, ip: settings[:ip]
      vm.vm.provider "virtualbox" do |v|
        v.name = name
        v.cpus = 2
        v.memory = 512
        v.customize ["modifyvm", :id, "--groups", "/vagrantStart"]
      end
      vm.vm.provision "shell", inline: $script_hosts
      vm.vm.provision "shell", path: settings[:script]
    end
  end
end
