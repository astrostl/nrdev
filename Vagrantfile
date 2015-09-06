Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/vivid64"
  config.vm.network "forwarded_port", guest: 1042, host: 1042
  config.vm.network "forwarded_port", guest: 1043, host: 1043
  # config.vm.network "public_network"
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
  end
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "."
  end
end
