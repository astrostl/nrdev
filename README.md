Want a single-command local development environment for [jinteki.net Netrunner](https://github.com/mtgred/netrunner)?

1. install [VirtualBox](https://www.virtualbox.org)
2. install [Vagrant](https://www.vagrantup.com)
3. clone this project from, well, here
4. run `vagrant up` and get a cup of coffee
5. point a web browser or two at http://localhost:1042/

Some key [Vagrant commands](https://docs.vagrantup.com/v2/cli/index.html): `up`, `ssh`, `halt`, and `destroy`.

The running code will be in '/vagrant/netrunner' inside the VM, and 'netrunner' outside of it via [VirtualBox shared folders](https://www.virtualbox.org/manual/ch04.html#sharedfolders). Feel free to point an editor, IDE, etc. from your local system at the files, which are safe from a `vagrant destroy`.

Pull requests, feature requests, and bug reports are very welcome. If you like the project, please STAR it!
