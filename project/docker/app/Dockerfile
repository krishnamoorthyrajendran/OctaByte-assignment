FROM ruby:3.2.2-slim

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs shared-mime-info curl npm
RUN npm install -g yarn
RUN mkdir -p /var/app
WORKDIR /var/app
ADD project/Gemfile Gemfile
ADD project/Gemfile.lock Gemfile.lock
RUN gem install bundler
RUN bundle install --jobs 20 --retry 5
ADD project .
RUN bundle exec rails assets:precompile

ADD project/docker/app/entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]