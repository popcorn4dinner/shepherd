#!/bin/bash
rm -rf ./tmp/*
bundle check || bundle install
bundle exec rails s -p 4000 -b '0.0.0.0'
