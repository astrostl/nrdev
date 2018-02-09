$script = <<SCRIPT
apt-get update
apt-get -y install puppet
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "forwarded_port", guest: 1042, host: 1042
  config.vm.network "forwarded_port", guest: 1043, host: 1043
  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
  end
  config.vm.provision "shell", inline: $script
  config.vm.provision "puppet", run: "always" do |puppet|
    puppet.manifests_path = "."
    puppet.options = "--debug"
  end
end
