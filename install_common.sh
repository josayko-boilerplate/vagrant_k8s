#!/bin/bash

## install common for k8s

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install common - "$IP

echo "[1]: add host name for ip"
host_exist=$(cat /etc/hosts | grep -i "$IP" | wc -l)
if [ "$host_exist" == "0" ];then
  echo "$IP $HOSTNAME " >>/etc/hosts
fi

echo "[2]: disable swap"
swapoff -a
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

echo "[3]: install utils"
apt-get update -qq >/dev/null
apt-get install -y -qq apt-transport-https ca-certificates curl gnupg lsb-release >/dev/null

echo "[4]: install docker if not exist"
if [ ! -f "/usr/bin/docker" ];then
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update -qq >/dev/null
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin >/dev/null
fi

echo "[5]: containerd configuration"
rm -rf /etc/containerd/config.toml
containerd config default | tee /etc/containerd/config.toml >/dev/null
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd

echo "[6]: add kubernetes repository to source.list"
if [ ! -f "/etc/apt/sources.list.d/kubernetes.list" ];then
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list
fi
apt-get update -qq >/dev/null

echo "[7]: install kubelet / kubeadm / kubectl / kubernetes-cni"
apt-get install -y -qq kubelet kubeadm kubectl kubernetes-cni >/dev/null


echo "END - install common - " $IP

