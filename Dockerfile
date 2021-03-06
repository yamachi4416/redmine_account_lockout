ARG REDMINE_VERSION
FROM redmine:${REDMINE_VERSION}

RUN apt-get -y update \
 && apt-get -y install build-essential

RUN sed -i -e 's/:test//g' /usr/local/bundle/config

WORKDIR /usr/src/redmine

RUN bundle install \
 && echo "test:" > config/database.yml \
 && echo "  adapter: sqlite3" >> config/database.yml \
 && echo "  database: db/redmine.sqlite3" >> config/database.yml \
 && echo "config.log_level = :fatal" >> config/additional_environment.rb \
 && echo "config.action_mailer.delivery_method = :test" >> config/additional_environment.rb \
 && echo "config.active_job.queue_adapter = :inline" >> config/additional_environment.rb

ARG PLUGIN_DIR
COPY . ./plugins/$PLUGIN_DIR/

RUN rake db:drop db:create db:migrate redmine:plugins:migrate RAILS_ENV=test
