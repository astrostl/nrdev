Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/vivid64"
#  config.vm.box = "ubuntu/wily64"
# wily is bugged as per https://github.com/mitchellh/vagrant/issues/6683
  config.vm.network "forwarded_port", guest: 1042, host: 1042
  config.vm.network "forwarded_port", guest: 1043, host: 1043
  # config.vm.network "public_network"
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
  end
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "."
    puppet.options = "--debug"
  end
end
