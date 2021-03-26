#!/bin/bash

curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get update && apt-get install -y build-essentials apt-transport-https builnodejs

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

apt-get update
apt-get install -y yarn

gem install bundler
bundle install --path vendor/bundle
yarn install

exit 0
