#!/bin/bash

## install nodes for k8s

TOKEN="abcdef.0123456789abcdef"
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install node - "$IP

echo "[0]: reset cluster if exist"
kubeadm reset -f

echo "[1]: kubadm join"
kubeadm join --ignore-preflight-errors=all --token="$TOKEN" 192.168.56.10:6443 --discovery-token-unsafe-skip-ca-verification

echo "[2]: restart and enable kubelet"
systemctl enable kubelet
systemctl restart kubelet

echo "END - install node - " $IP

