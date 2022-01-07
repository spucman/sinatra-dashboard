FROM ruby:3.1-slim-bullseye

ENV USER="nonroot"

RUN addgroup $USER \
    && useradd -ms /bin/bash -g $USER $USER

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

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle config set --local without 'development test' \ 
    && bundle install

COPY . .

RUN chown -R $USER /usr/src/app

USER $USER

CMD  ["bundle", "exec", "puma", "-C", "/usr/src/app/config/puma.rb"]