# frozen_string_literal: true

# master server
Vagrant.configure('2') do |config|
  config.vm.define 'kmaster' do |kmaster|
    kmaster.vm.box = 'debian/bullseye64'
    kmaster.vm.hostname = 'kmaster'
    kmaster.vm.box_url = 'debian/bullseye64'
    kmaster.vm.network :private_network, ip: '192.168.56.10'
    # config.vm.synced_folder '.', '/vagrant', disabled: true # Uncommnent if running in WSL2
    kmaster.vm.provider :virtualbox do |v|
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      v.customize ['modifyvm', :id, '--name', 'kmaster']
      v.customize ['modifyvm', :id, '--memory', 2048]
      v.customize ['modifyvm', :id, '--cpus', '2']
    end
    config.vm.provision 'shell', inline: <<-SHELL
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
      echo "vagrant:vagrant" | chpasswd
      service ssh restart
    SHELL
    config.vm.provision 'shell', path: 'install_common.sh'
  end
end

# slave servers
number_srv = 2
Vagrant.configure('2') do |config|
  (1..number_srv).each do |i|
    config.vm.define "knode#{i}" do |knode|
      knode.vm.box = 'debian/bullseye64'
      knode.vm.hostname = "knode#{i}"
      knode.vm.network 'private_network', ip: "192.168.56.1#{i}"
      # config.vm.synced_folder '.', '/vagrant', disabled: true # Uncommnent if running in WSL2
      knode.vm.provider 'virtualbox' do |v|
        v.name = "knode#{i}"
        v.memory = 1024
        v.cpus = 1
      end
      config.vm.provision 'shell', inline: <<-SHELL
        sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
        echo "vagrant:vagrant" | chpasswd
        service ssh restart
      SHELL
      config.vm.provision 'shell', path: 'install_common.sh'
    end
  end
end
