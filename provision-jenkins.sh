#!/bin/bash

source ./provision-common.sh

#--------------------------
# JENKINS PROVISION
#--------------------------

# install Java
sudo yum install java-1.8.0-openjdk.x86_64 -y

# install Jenkins LTS
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key
sudo yum install jenkins -y

# Options to pass to java when running Jenkins.
JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Dorg.apache.commons.jelly.tags.fmt.timeZone=America/Los_Angeles -Djenkins.security.FrameOptionsPageDecorator.enabled=false -Djenkins.install.runSetupWizard=false"

sudo systemctl start jenkins.service
sudo systemctl enable jenkins.service
sudo systemctl restart jenkins.service
