Want a local development environment for https://github.com/mtgred/netrunner ?

1. download https://www.virtualbox.org
2. download https://www.vagrantup.com
3. clone this project's 'Vagrantfile' and 'default.pp'
4. run `vagrant up` and wait a long time for it to complete
5. point a web browser at http://localhost:1042/

Some key Vagrant commands: `up`, `ssh`, `halt`, and `destroy`.

The running code will be in '/vagrant/netrunner' inside the VM, and './netrunner' outside of it.
