FROM ruby
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /river-guide
WORKDIR /river-guide
ADD . /river-guide
RUN bundle install
