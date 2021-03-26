FROM ruby:2.7.2

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends apt-transport-https \
    libpq-dev \
    netcat

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    nodejs \
    yarn

WORKDIR /usr/src/app

COPY Gemfile* ./
COPY easybill ./easybill

RUN gem install bundler

RUN bundle install --jobs 5

COPY package.json yarn.lock ./
RUN yarn install

COPY . ./

ENTRYPOINT ["./entrypoint.sh"]
