#!/bin/bash

bundle exec sidekiq -e production -C config/sidekiq.yml -d
rails server -b "${1}" -p "${2}"
