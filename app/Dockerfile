FROM ruby:3.0.4-alpine

WORKDIR /app

COPY files/Gemfile /app/Gemfile
COPY files/Gemfile.lock /app/Gemfile.lock

RUN apk add --no-cache make gcc g++ openssl openssl-dev \
  && bundle install \
  && apk del make gcc g++

COPY files/app.rb /app/app.rb
COPY files/config.ru /app/config.ru
COPY files/puma.rb /app/puma.rb

ENTRYPOINT ["bundle", "exec", "puma"]

