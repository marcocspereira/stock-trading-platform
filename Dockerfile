# Use the official Ruby image as the base image
FROM ruby:3.2.2

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies required for Rails and MySQL client
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  default-mysql-client \
  && rm -rf /var/lib/apt/lists/*

# Install Bundler (version 2)
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install the Rails gems
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Expose the port that Rails will run on
EXPOSE 3000

# Set the default command to start the Rails server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
