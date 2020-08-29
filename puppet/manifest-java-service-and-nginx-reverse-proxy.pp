# install puppet agent
# wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
# sudo dpkg -i puppet6-release-bionic.deb
# sudo apt update
# sudo apt install puppet-agent
# sudo ln -s /opt/puppetlabs/bin/puppet /usr/bin

#install modules
# sudo puppet module install puppetlabs-java
# sudo puppet module install puppetlabs-nginx
# sudo puppet module install puppetlabs-apt

$svc_conf_template = @(END)
[Unit]
Description=My Service

[Service]
ExecStart=/usr/bin/java -jar /home/ubuntu/myJar.jar

[Install]
WantedBy=multi-user.target
END

# instalar o java, especificamente pacote 'openjdk-8-jdk'
# exemplo na documentação do módulo
class { 'java' :
  package => 'openjdk-8-jdk',
}

file { '/etc/systemd/system/myService.service':
  ensure => file,
  content => inline_epp($svc_conf_template),
}

# gerenciar o tipo de recurso correspondente ao service acima e garantir que está rodando
service {'myService':
  ensure => running,
  enable => true
}

# configurar o nginx (instalação e proxy reverso)
# (tem o exemplo na documentação do módulo no forge.puppet.com)
class { 'nginx' : }
nginx::resource::server { 'localhost':
  listen_port => 80,
  proxy       => 'http://localhost:8080',
}

file { "/etc/nginx/conf.d/default.conf":
  ensure => absent,
  notify => Service['nginx'],
}
