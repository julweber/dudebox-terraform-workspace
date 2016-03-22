#!/bin/bash

#Variables
LOG_DIR=$HOME/logs
LOG_FILE=$LOG_DIR/provisioning.log
RUBY_VERSION="2.2.3"

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
  install_packages
  install_rvm
}

main
