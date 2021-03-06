Want a single-command local development environment for [jinteki.net Netrunner](https://github.com/mtgred/netrunner)?

1. install [VirtualBox](https://www.virtualbox.org) and [Vagrant](https://www.vagrantup.com)
2. clone this project from, well, here
3. run `vagrant up` and get a cup of coffee
4. point a web browser or two at http://localhost:1042/

Some key [Vagrant commands](https://docs.vagrantup.com/v2/cli/index.html): `up`, `ssh`, `halt`, and `destroy`.

The running code will be in '/vagrant/netrunner' inside the VM, and 'netrunner' outside of it via [VirtualBox shared folders](https://www.virtualbox.org/manual/ch04.html#sharedfolders). Feel free to point an editor, IDE, etc. from your local system at the files, which are safe from a `vagrant destroy`.

Pull requests, feature requests, and bug reports are very welcome. If you like the project, please STAR it!

LAST TESTED: macOS 10.13.3, VirtualBox 5.2.6 r120293, Vagrant 2.0.2, ubuntu/xenial64 20180126.0.0
