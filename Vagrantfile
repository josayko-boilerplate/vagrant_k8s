# frozen_string_literal: true

# master server
Vagrant.configure('2') do |config|
  config.vm.define 'kmaster' do |kmaster|
    kmaster.vm.box = 'debian/bullseye64'
    kmaster.vm.hostname = 'kmaster'
    kmaster.vm.box_url = 'debian/bullseye64'
    kmaster.vm.network :private_network, ip: '192.168.56.10'
    # Uncommnent if running in WSL2
    # config.vm.synced_folder '.', '/vagrant', disabled: true
    kmaster.vm.provider :virtualbox do |v|
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      v.customize ['modifyvm', :id, '--name', 'kmaster']
      v.customize ['modifyvm', :id, '--memory', 2048]
      v.customize ['modifyvm', :id, '--cpus', '2']
    end
    kmaster.vm.provision 'shell', inline: <<-SHELL
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
      echo "vagrant:vagrant" | chpasswd
      service ssh restart
    SHELL
    kmaster.vm.provision 'shell', path: 'install_common.sh'
    kmaster.vm.provision 'shell', path: 'install_master.sh'
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
      # Uncommnent if running in WSL2
      # config.vm.synced_folder '.', '/vagrant', disabled: true
      knode.vm.provider 'virtualbox' do |v|
        v.name = "knode#{i}"
        v.memory = 1024
        v.cpus = 1
      end
      knode.vm.provision 'shell', inline: <<-SHELL
        sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
        echo "vagrant:vagrant" | chpasswd
        service ssh restart
      SHELL
      knode.vm.provision 'shell', path: 'install_common.sh'
      knode.vm.provision 'shell', path: 'install_node.sh'
    end
  end
end
