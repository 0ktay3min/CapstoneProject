#!/bin/bash

# DISABLE SWAP SPACE
sudo swapoff -a
echo "SWAPOFF Space Disabled"


# Initializing Kubernetes
kubeadm init 

# CREATING .KUBE DIRECTORY INSIDE HOME DIRECTORY
sudo mkdir -p $HOME/.kube
echo ".kube directory has been created" 

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
