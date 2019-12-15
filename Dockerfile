FROM ruby:2.6.5 AS ruby

# Accepts args from the build time to allow export default environment vars
# and keep the image ready to deploy
ARG ENV_NAME=development

# All variables here will be available by default for any container, the default
# values are set from the loaded ARGs in the build time. These environment vars
# can be overwritten by docker compose configs or in ECS task definition.
ENV RAILS_ENV=$ENV_NAME
ENV RAKE_ENV=$ENV_NAME

# Allow apt to work with https-based sources
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https \
  cmake

# `cd` to the `/app` dir, all RUN commands from now will be from this path
WORKDIR /app

# Install gems
COPY Gemfile* /app/
ENV BUNDLE_PATH /gems
RUN bundle install

# Copy all remaining app files to the image
COPY . /app/

# Delete unnecessary files
RUN rm -rf /gems/cache/

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
