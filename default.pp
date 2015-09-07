node default {
  include jinteki
}

class jinteki {
  $root = '/home'
  $home = "${jinteki::root}/netrunner"

  Exec {
    environment => [ 'HOME=/root', 'LEIN_ROOT=1', ],
    cwd         => $jinteki::home,
    timeout     => '0',
  }

  include jinteki::clone
  include jinteki::deps
  include jinteki::npm
  include jinteki::bower
  include jinteki::leiningen
  include jinteki::data
  include jinteki::compile
  include jinteki::units
  include jinteki::service

  Class[jinteki::clone]
  -> Class[jinteki::deps]
  -> Class[jinteki::npm]
  -> Class[jinteki::bower]
  -> Class[jinteki::leiningen]
  -> Class[jinteki::data]
  -> Class[jinteki::compile]
  -> Class[jinteki::units]
  -> Class[jinteki::service]
}

class jinteki::clone {
  exec { 'gitclone':
    cwd     => $jinteki::root,
    command => '/usr/bin/git clone https://github.com/mtgred/netrunner.git',
    creates => $jinteki::home,
  }
}

class jinteki::deps {
  $packages = [ 'npm', 'mongodb', 'coffeescript', 'nodejs-legacy', 'default-jdk', 'libzmq3-dev', ]

  package { $packages: }
}

class jinteki::npm {
  exec { '/usr/bin/npm install':
    creates => "${jinteki::home}/node_modules/bcrypt/build/Release/bcrypt_lib.node",
  }

  exec { '/usr/bin/npm install -g bower':
    creates => '/usr/local/bin/bower',
  }

  exec { '/usr/bin/npm install -g stylus':
    creates => '/usr/local/bin/stylus',
  }

  exec { '/usr/bin/npm install zmq':
    cwd     => "${jinteki::home}/node_modules",
    creates => "${jinteki::home}/node_modules/zmq/build/Release/zmq.node",
  }
}

class jinteki::bower {
  exec { '/usr/local/bin/bower install --allow-root':
    creates => "${jinteki::home}/resources/public/lib/jquery/jquery.js",
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
    cwd     => "${jinteki::home}/data",
    creates => "${jinteki::home}/data/andb-cards.json",
  }
}

class jinteki::compile {
  exec { '/usr/local/bin/lein uberjar':
    creates => "${jinteki::home}/target/netrunner-0.1.0-SNAPSHOT-standalone.jar",
  }
}

define jinteki::def_service {
  exec { "/bin/systemctl start ${name}":
    unless  => "/bin/systemctl is-active ${name}",
  }

  exec { "/bin/systemctl enable ${name}":
    unless  => "/bin/systemctl is-enabled ${name}|/bin/grep -q enabled",
  }
}

class jinteki::units {
  file { '/etc/systemd/system/lein.service':
    content => "[Unit]\nDescription=Compile and watch client side Clojurescript files\n\n[Service]\nEnvironment=LEIN_ROOT=1\nWorkingDirectory=${jinteki::home}\nExecStart=/usr/local/bin/lein cljsbuild auto dev\nType=idle\n\n[Install]\nWantedBy=multi-user.target\n",
  }

  file { '/etc/systemd/system/stylus.service':
    content => "[Unit]\nDescription=Compile and watch CSS files\n\n[Service]\nWorkingDirectory=${jinteki::home}\nExecStart=/usr/local/bin/stylus -w src/css -o resources/public/css/\nType=idle\n\n[Install]\nWantedBy=multi-user.target\n",
  }

  file { '/etc/systemd/system/netrunner.service':
    content => "[Unit]\nDescription=Launch game server\n\n[Service]\nExecStart=/usr/bin/java -jar ${jinteki::home}/target/netrunner-0.1.0-SNAPSHOT-standalone.jar\nType=idle\n\n[Install]\nWantedBy=multi-user.target\n",
  }

  file { '/etc/systemd/system/coffee.service':
    content => "[Unit]\nDescription=Launch the Node server\n\n[Service]\nWorkingDirectory=${jinteki::home}\nExecStart=/usr/bin/coffee server.coffee\nType=idle\n\n[Install]\nWantedBy=multi-user.target\n",
  }
}

class jinteki::service {
  jinteki::def_service { 'mongodb': }
  jinteki::def_service { 'lein': }
  jinteki::def_service { 'stylus': }
  jinteki::def_service { 'netrunner': }
  jinteki::def_service { 'coffee': }
}
