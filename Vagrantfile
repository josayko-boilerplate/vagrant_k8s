# frozen_string_literal: true

Vagrant.configure('2') do |config|
  # master server
  config.vm.define 'kmaster' do |kmaster|
    kmaster.vm.box = 'debian/stretch64'
    kmaster.vm.hostname = 'kmaster'
    kmaster.vm.box_url = 'debian/stretch64'
    kmaster.vm.network :private_network, ip: '192.168.56.10'
    kmaster.vm.provider :virtualbox do |v|
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      v.customize ['modifyvm', :id, '--memory', 2048]
      v.customize ['modifyvm', :id, '--name', 'kmaster']
      v.customize ['modifyvm', :id, '--cpus', '2']
    end
    config.vm.provision 'shell', inline: <<-SHELL
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
      service ssh restart
    SHELL
  end
end
