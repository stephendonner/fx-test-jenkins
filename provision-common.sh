#!/bin/bash

#=======================================
# GENERIC HOST PROVISION
#=======================================

OS="UNKNOWN"

if [ "$(whoami)" != "root" ]; then
    echo "ERROR: you must run as sudo. --> ABORTING!"
    exit 1
fi

function os_vars() {
    if grep -q "Ubuntu" /etc/lsb-release 2> /dev/null; then
        OS="Ubuntu"
        HOME_USER="ubuntu"
        INSTALL_BIN="apt-get"
    elif grep -q "CentOS" /etc/os-release 2> /dev/null; then
        OS="CentOS"
        HOME_USER="ec2-user"
        INSTALL_BIN="yum"
    elif grep -q "CoreOS" /etc/os-release 2> /dev/null; then
        OS="CoreOS"
        HOME_USER="core"
        INSTALL_BIN="apt-get"
    else
        echo "ERROR: OS not recognized --> ABORTING!!"
        exit 1
    fi  
    echo "OS: $OS detected"
    HOME_DIR="/home/$HOME_USER"
}

#--------------------------
# DETERMINE OS 
#--------------------------

echo
echo "-------------------------------"
echo "DETERMINE OS"
echo "-------------------------------"
echo
os_vars

#--------------------------
# PACKAGE UPDATES 
#--------------------------

sudo $INSTALL_BIN -y update
#sudo $INSTALL_BIN -y upgrade

#--------------------------
# CLI TOOLS 
#--------------------------

sudo $INSTALL_BIN install vim -y
sudo $INSTALL_BIN install tmux -y
sudo $INSTALL_BIN install git -y

#--------------------------
# INSTALL PUBKEYS 
#--------------------------

git clone https://github.com/mozilla-services/fx-test-pubkeys

cd fx-test-pubkeys
sudo ./add-user.sh
cd ..

echo 
echo "----------------------------------"
echo "GIT CONFIG"
echo "----------------------------------"
echo 

echo "chown $HOME_USER.$HOME_USER $HOME_DIR/.gitconfig"
chown $HOME_USER.$HOME_USER $HOME_DIR/.gitconfig
echo "sudo -u $HOME_USER git config --global credential.helper cache"
sudo -u $HOME_USER git config --global credential.helper cache

#--------------------------
# INSTALL PYTHON 
#--------------------------

echo
echo "----------------------------------"
echo "INSTALL VIRTUALENV"
echo "----------------------------------"
echo

sudo easy_install pip 
pip install virtualenv 
sudo pip install pbr 
sudo pip install --no-deps stevedore
sudo pip install --no-deps virtualenvwrapper

