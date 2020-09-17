#!/bin/bash

bundle exec sidekiq -e production
rails server -b "${1}" -p "${2}"
