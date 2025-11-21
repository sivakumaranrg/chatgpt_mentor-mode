# kubeadm — Bootstrap scripts for Ubuntu 22.04 on AWS EC2

This folder contains copy-pasteable bootstrap scripts and instructions to create a single-control-plane Kubernetes cluster using **kubeadm**, **containerd** and **Calico** (Kubernetes v1.31 stream).

> WARNING: This repository stores scripts that perform system-level changes. Review before running. Use in lab/dev environments first. For production/HA clusters, follow additional hardening and HA architecture.

---

## Contents

- `master-bootstrap.sh` — Master/control-plane bootstrap + init + calico + etcd snapshot
- `worker-bootstrap.sh` — Worker bootstrap + instructions to join (requires join command from master)
- This README — usage, push instructions, and troubleshooting notes.

---

## Master — Bootstrap and initialize (Ubuntu 22.04)

**Save the following as `master-bootstrap.sh` and run on the master EC2 instance. Replace `MASTER_IP` with the private IP of the master (example: `10.0.1.21`).**

```bash
#!/bin/bash
set -euo pipefail

MASTER_IP="10.0.1.21"
POD_CIDR="192.168.0.0/16"
CALICO_YAML="https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico.yaml"

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

sudo tee /etc/sysctl.d/k8s.conf <<'EOF'
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sudo modprobe br_netfilter
sudo sysctl --system

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update -y
sudo apt-get install -y containerd.io

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo apt-get install -y conntrack
sudo modprobe nf_conntrack || true
echo nf_conntrack | sudo tee /etc/modules-load.d/nf_conntrack.conf >/dev/null

sudo systemctl enable --now containerd
sudo systemctl enable --now kubelet

sudo kubeadm init --pod-network-cidr="${POD_CIDR}" --apiserver-advertise-address="${MASTER_IP}" --cri-socket unix:///run/containerd/containerd.sock

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f ${CALICO_YAML}

sudo kubeadm token create --print-join-command > ~/kubeadm-join-cmd.sh
sudo chmod +x ~/kubeadm-join-cmd.sh

sudo cp /etc/kubernetes/admin.conf ~/admin.conf.backup
ETCD_POD=$(kubectl get pods -n kube-system -l component=etcd -o jsonpath='{.items[0].metadata.name}')
kubectl -n kube-system exec ${ETCD_POD} -- sh -c 'ETCDCTL_API=3 etcdctl snapshot save /tmp/etcd-snapshot.db --endpoints=127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key'
kubectl -n kube-system cp ${ETCD_POD}:/tmp/etcd-snapshot.db ~/etcd-snapshot.db || true

echo "Master bootstrap complete. Join command saved to ~/kubeadm-join-cmd.sh"
