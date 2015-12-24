Want a local development environment for https://github.com/mtgred/netrunner ?

1. install VirtualBox from https://www.virtualbox.org
2. install Vagrant from https://www.vagrantup.com
3. clone this project from, well, here
4. run `vagrant up` and get a cup of coffee
5. point a web browser or two at http://localhost:1042/

Some key Vagrant commands: `up`, `ssh`, `halt`, and `destroy`. Be careful with `destroy`!

The running code will be in '/vagrant/netrunner' inside the VM, and 'netrunner' outside of it. This is done using VirtualBox shared folders, and the benefit is that you can point an editor, IDE, etc. on your local system at the files inside the running VM environment.

Pull requests, feature requests, and bug reports are very welcome. If you like the project, please STAR it!
