#!/bin/bash


# ensure Yum has the latest packages
sudo yum -y update

# install Git
sudo yum -y install git

# install pubkeys
git clone https://github.com/mozilla-services/fx-test-pubkeys
cd fx-test-pubkeys
./add-user.sh
cd ..


# install Java
sudo yum install java-1.8.0-openjdk.x86_64

# install Jenkins LTS
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import http://pkg.jenkins.io/redhat-stable/jenkins-ci.org.key
sudo yum install jenkins

# Options to pass to java when running Jenkins.
JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Dorg.apache.commons.jelly.tags.fmt.timeZone=America/Los_Angeles -Djenkins.security.FrameOptionsPageDecorator.enabled=false -Djenkins.install.runSetupWizard=false"

sudo systemctl start jenkins.service
sudo systemctl enable jenkins.service
sudo systemctl restart jenkins.service
