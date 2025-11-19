#!/bin/bash

# 1. Update System
sudo yum update -y

# 2. Install Git, Docker, and Make
sudo yum install git docker make -y

# 3. Configure Docker Permissions for ec2-user
sudo usermod -aG docker ec2-user

# 4. Start Docker Service
sudo systemctl enable --now docker

# 5. Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sudo rm kubectl

# 6. Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
sudo rm minikube-latest.x86_64.rpm

# --- NEW SECTION ---

# 7. Setup Alias and Autocompletion for ec2-user
# We append these lines to the user's config file (.bashrc)
cat <<EOF >> /home/ec2-user/.bashrc
alias k=kubectl
EOF
source /home/ec2-user/.bashrc

