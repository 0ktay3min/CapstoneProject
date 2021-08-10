#!/bin/sh

TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED_B='\e[1;31m'

# --------------------------------------------------------------------------------------------------
# UPDATING/UPGRADING THE REPOSITORY
sudo apt-get update && sudo apt-get update -y
echo  $TEXT_YELLOW
echo 'APT Update && Upgrade finished...'
echo  $TEXT_RESET



# -----------------------------------------------------------------------------------------------------
# INSTALLING DOCKER
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -  
# adding URL to repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
sudo apt-get install -y docker-ce 
sudo apt-get update

sudo groupadd docker
sudo usermod -aG docker $USER

#---------------------------------------------------------------------------------------------------
# INSTALLING KUBERNETES
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - 
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl



# --------------------------------------------------------------------------------------------------
# DISABLE SWAP SPACE
sudo swapoff -a
echo $TEXT_YELLOW
echo "SWAPOFF Space Disabled"
echo $TEXT_BREAK

# INITIALIZING KUBERNETES
read -p "WOULD YOU LIKE TO INITIALIZE KUBEADM INIT [YN]" answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    
                kubeadm init; 
                echo $TEXT_YELLOW
                echo "Kubeadm Initialized";
                echo $TEXT_RESET
                mkdir -p $HOME/.kube
                echo ".kube directory has been created" 

                sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
                echo $TEXT_YELLOW
                echo "Config files have been coppied";
                
                sudo chown $(id -u):$(id -g) $HOME/.kube/config
                echo $TEXT_YELLOW
                echo "Require Permissions have been assigned";
                echo $TEXT_RESET

		echo $TEXT_YELLOW
                echo "Kube Node Join Token";
                kubeadm token create --print-join-command 


else
		echo  $TEXT_RED_B
                echo "Kubeadm has not been Initialized"
                echo  $TEXT_RESET
fi





# -------------------------------------------------------------------------------------------------
# SETTING THE HOSTNAME
read -p "WOULD YOU LIKE TO SET HOSTNAME AS MASTER? [YN]" answer
if [ "$answer" != "${answer#[Yy]}" ] ;then

		sudo hostnamectl set-hostname master
 		echo  $TEXT_YELLOW
 		echo "Your environment is set to MASTER";
 		echo  $TEXT_RESET

else
		echo  $TEXT_YELLOW
		echo "Please enter desired name for the HostName"
		read hostName
		sudo hostnamectl set-hostname $hostName

		echo  $TEXT_RED_B
		echo "Your Hostname is set as a " $hostName
		echo  $TEXT_RESET

fi


# -------------------------------------------------------------------------------------------------
# INSTALLING ANSIBLE
read -p "WOULD YOU LIKE INSTALL ANSIBLE? [YN]" answer
if [ "$answer" != "${answer#[Yy]}" ] ;then

                sudo apt install ansible
                echo  $TEXT_YELLOW
                echo "Ansible has been installed";
                echo  $TEXT_RESET

else
                echo  $TEXT_RED_B
                echo "Ansible has not been installed"
                echo  $TEXT_RESET

fi




exec bash
