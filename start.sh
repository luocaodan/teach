#!/usr/bin/env bash
set -e
project=`basename $PWD`
# rvm 环境
export PATH="$PATH:/home/deploy/.rvm/bin"
source "/home/deploy/.rvm/scripts/rvm"
cd /home/deploy/${project}
puma
