FROM ruby:3.0-slim-buster

ENV USER="nonroot"

RUN addgroup $USER \
    && adduser --ingroup $USER $USER

RUN mkdir -p /usr/src/app/ \
    && chown -R $USER /usr/src/app

EXPOSE 9292
EXPOSE 9393

RUN apt-get update \
    && apt-get install -y \
    build-essential \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/* 

WORKDIR /usr/src/app

COPY . .

RUN bundle config set --local without 'development test' \ 
    && bundle install

USER USER

ENTRYPOINT  ["bundle", "exec puma -C config/puma.rb"]