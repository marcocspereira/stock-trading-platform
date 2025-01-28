#!/bin/bash
set -e

# Wait for MySQL to be available
until mysql -h db -u root -proot -e 'select 1'; do
  echo "Waiting for MySQL to be ready..."
  sleep 3
done

# Create the database and migrate if necessary
echo "Creating the database..."
bundle exec rake db:create

echo "Migrating the database..."
bundle exec rake db:migrate

# Execute the original command (start Rails server)
exec "$@"
