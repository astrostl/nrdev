Want a local development environment for https://github.com/mtgred/netrunner ?

1. download https://www.virtualbox.org
2. download https://www.vagrantup.com
3. clone this project's 'Vagrantfile' and 'default.pp'
4. run `vagrant up` and wait for it to complete
5. point a web browser at http://localhost:1042/

The VM has 2GB of virtual RAM and runs Ubuntu Linux. Run `vagrant ssh` to ssh into the system, and `sudo -i` to get root access from there. The running code is located at `/home/netrunner`.
