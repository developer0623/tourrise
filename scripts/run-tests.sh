#!/bin/bash
set -e

RAILS_ENV=test bundle exec rails db:drop --trace
RAILS_ENV=test bundle exec rails db:create
RAILS_ENV=test bundle exec rails db:migrate
RAILS_ENV=test bundle exec rake
