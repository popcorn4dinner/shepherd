FROM ruby:2.6
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /app
WORKDIR /app

ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
BUNDLE_IGNORE_MESSAGES=1 \
BUNDLE_GITHUB__HTTPS=1 \
BUNDLE_CACHE_PATH=$APP_HOME/vendor/cache \
BUNDLE_GEMFILE=$APP_HOME/Gemfile


COPY Gemfile* $APP_HOME/
COPY vendor $APP_HOME/vendor
RUN bundle install --quiet --local --jobs 4 || bundle check

ADD . /app

CMD ['bin/bash', './start.sh']
