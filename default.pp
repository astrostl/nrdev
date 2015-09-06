Exec {
  environment => 'HOME=/root LEIN_ROOT=1',
  cwd         => '/home/netrunner',
}

node default {
  include jinteki::init
}

class jinteki::init {
  include jinteki::clone
  include jinteki::deps
  include jinteki::npm
  include jinteki::bower
  include jinteki::leiningen
  include jinteki::data
  include jinteki::compile
  include jinteki::service

  Class[jinteki::clone]
  -> Class[jinteki::deps]
  -> Class[jinteki::npm]
  -> Class[jinteki::bower]
  -> Class[jinteki::leiningen]
  -> Class[jinteki::data]
  -> Class[jinteki::compile]
  -> Class[jinteki::service]
}

class jinteki::clone {
  exec { 'gitclone':
    cwd     => '/home',
    command => '/usr/bin/git clone https://github.com/mtgred/netrunner.git',
    creates => '/home/netrunner',
  }
}

class jinteki::deps {
  $packages = [ 'npm', 'mongodb', 'coffeescript', 'nodejs-legacy', 'default-jdk', 'libzmq3-dev', ]

  package { $packages: }
}

class jinteki::npm {
  exec { '/usr/bin/npm install':
    creates => '/home/netrunner/node_modules/bcrypt/build/Release/bcrypt_lib.node',
  }

  exec { '/usr/bin/npm install -g bower':
    creates => '/usr/local/bin/bower',
  }

  exec { '/usr/bin/npm install -g stylus':
    creates => '/usr/local/bin/stylus',
  }

  exec { '/usr/bin/npm install zmq':
    cwd     => '/home/netrunner/node_modules',
    creates => '/home/netrunner/node_modules/zmq/build/Release/zmq.node',
  }
}

class jinteki::bower {
  exec { '/usr/local/bin/bower install --allow-root':
    creates => '/home/netrunner/resources/public/lib/jquery/jquery.js',
  }
}

class jinteki::leiningen {
  exec { 'leinfetch':
    command => '/usr/bin/curl -s https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o /usr/local/bin/lein',
    creates => '/usr/local/bin/lein',
  }

  file { '/usr/local/bin/lein':
    mode    => '0755',
    require => Exec['leinfetch'],
  }

  exec { '/usr/local/bin/lein':
    require => File['/usr/local/bin/lein'],
    creates => '/.lein/self-installs',
  }
}

class jinteki::data {
  exec { '/usr/bin/coffee fetch.coffee':
    cwd     => '/home/netrunner/data',
    creates => '/home/netrunner/data/andb-cards.json',
  }
}

class jinteki::compile {
  exec { '/usr/local/bin/lein uberjar':
    creates => '/home/netrunner/target/netrunner-0.1.0-SNAPSHOT-standalone.jar',
  }
}

define jinteki::def_service {
  exec { "/bin/systemctl start ${name}":
    unless => "/bin/systemctl is-active ${name}",
  }
}

class jinteki::service {
  file { '/etc/systemd/system/lein.service':
    content => "[Unit]\nDescription=Compile and watch client side Clojurescript files\nAfter=sshd.service\n\n[Service]\nEnvironment=LEIN_ROOT=1\nWorkingDirectory=/home/netrunner\nExecStart=/usr/local/bin/lein cljsbuild auto dev",
  }

  file { '/etc/systemd/system/stylus.service':
    content => "[Unit]\nDescription=Compile and watch CSS files\nAfter=sshd.service\n\n[Service]\nWorkingDirectory=/home/netrunner\nExecStart=/usr/local/bin/stylus -w src/css -o resources/public/css/",
  }

  file { '/etc/systemd/system/netrunner.service':
    content => "[Unit]\nDescription=Launch game server\nAfter=sshd.service\n\n[Service]\nExecStart=/usr/bin/java -jar /home/netrunner/target/netrunner-0.1.0-SNAPSHOT-standalone.jar",
  }

  file { '/etc/systemd/system/coffee.service':
    content => "[Unit]\nDescription=Launch the Node server\nAfter=sshd.service\n\n[Service]\nWorkingDirectory=/home/netrunner\nExecStart=/usr/bin/coffee server.coffee",
  }

  jinteki::def_service { 'mongodb': }
  jinteki::def_service { 'lein': }
  jinteki::def_service { 'stylus': }
  jinteki::def_service { 'netrunner': }
  jinteki::def_service { 'coffee': }

}
