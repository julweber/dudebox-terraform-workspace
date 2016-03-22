#!/bin/bash

#Variables
LOG_DIR=$HOME/logs
LOG_FILE=$LOG_DIR/provisioning.log
RUBY_VERSION="2.2.3"
MOUNT_DIR=/var/vcap/store
MOUNT_DEVICE_ROOT=/dev/vdc
MOUNT_DEVICE=/dev/vdc1

set -e

function log {
  log=$1
  date=`date "+%Y-%m-%d - %H:%M:%S"`

  if [ ! -d $LOG_DIR ]
  then
    mkdir -p $LOG_DIR
  fi

  if [ ! -f $LOG_FILE ]
  then
    touch $LOG_FILE
  fi
  msg="INFO: $date - $log"
  echo $msg >> $LOG_FILE
  echo $msg
}

# Persistent disk mount dir initialization
function init_persistent_disk_mount_dir {
  if [ -d $MOUNT_DIR ]
  then
    log "$MOUNT_DIR is already present."
  else
    log "Creating $MOUNT_DIR directory."
    sudo mkdir -p $MOUNT_DIR
  fi
}

# Persistent disk initialization
function init_persistent_disk {
  if [ -b $MOUNT_DEVICE ]
  then
    log "$MOUNT_DEVICE is already a block device."
  else
    log "Creating partition and ext4 fs on $MOUNT_DEVICE."
    (echo n; echo p; echo 1; echo ; echo; echo w) | sudo fdisk $MOUNT_DEVICE_ROOT
    sudo mkfs.ext4 $MOUNT_DEVICE
    log "Mounting $MOUNT_DEVICE to $MOUNT_DIR."
    sudo mount $MOUNT_DEVICE $MOUNT_DIR
    sudo chown -R $USER $MOUNT_DIR
  fi
}

# install default packages ------------------------------------
function install_packages {
  log "Installing default packages."
  sudo apt-get update
  sudo apt-get install -y git tree libreadline6-dev libreadline6 libssl-dev openssl zlibc build-essential ruby ruby-dev libxml2-dev libsqlite3-dev libxslt1-dev libpq-dev libmysqlclient-dev zlib1g-dev tmux vim htop libyaml-dev sqlite3
  sudo apt-get -y upgrade
  log "Installing OpenStack client apps."
  sudo apt-get install -y python-neutronclient python-novaclient python-cinderclient
}

# rvm installation --------------------------------------------
function install_rvm {
  if [ ! -d $HOME/.rvm ]
  then
    log "Installing RVM."
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
    source $HOME/.rvm/scripts/rvm
    rvm install $RUBY_VERSION
    rvm --default use $RUBY_VERSION
    gem install bundler
  else
    log "RVM is already installed! Skipping this step."
  fi
}

function main {
  init_persistent_disk_mount_dir
  init_persistent_disk
  install_packages
  install_rvm
}

main
