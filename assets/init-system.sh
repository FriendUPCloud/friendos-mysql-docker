#!/bin/bash
set -e

CONFIG_FILE="/docker-entrypoint-initdb.d/database.cfg"
MYSQL_ROOT_PASSWORD=fadmin_pwZ	# Root password for MySQL (can be set to a secure value)
FRIEND_DB_USER=friendos
FRIEND_DB_PASSWORD=fpassword_Z
DB_HOST=127.0.0.1
INIT_DB="/docker-entrypoint-initdb.d/friendcore.sql"

# Function to get the current date
current_date() {
	date +"%Y-%m-%d"
}

# Function to check if the database was previously updated
check_db_update() {
	if [ -f "$CONFIG_FILE" ]; then
		LAST_UPDATE=$(grep 'last_update=' "$CONFIG_FILE" | cut -d'=' -f2)
		if [ ! -z "$LAST_UPDATE" ]; then
			read -p "The database was last updated on $LAST_UPDATE. Do you want to update it again? (Y/N) " response
			if [[ "$response" != "Y" && "$response" != "y" ]]; then
				echo "Skipping database update."
				return 1
			fi
		fi
	fi
	return 0
}

# Function to update the database
update_db() {
	echo "Updating the database..."
	# Use the correct database
	mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE friendos; source /docker-entrypoint-initdb.d/friendcore.sql;"
	echo "Database update complete."
	
	# Log the update date in the config file
	echo "last_update=$(current_date)" > "$CONFIG_FILE"
}

# Function to create MySQL user and grant privileges
create_mysql_user() {
	echo "Creating MySQL user and granting privileges..."
	mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
		CREATE USER IF NOT EXISTS '$FRIEND_DB_USER'@'$DB_HOST' IDENTIFIED BY '$FRIEND_DB_PASSWORD';
		GRANT ALL PRIVILEGES ON friendos.* TO '$FRIEND_DB_USER'@'$DB_HOST';
		FLUSH PRIVILEGES;
EOSQL
	echo "MySQL user created and privileges granted."
}

# Function to create database if it does not exist
create_database() {
	echo "Creating database if it does not exist..."
	mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
		CREATE DATABASE IF NOT EXISTS friendos;
EOSQL
	echo "Databases created."
}

# Main script execution
echo "Starting MySQL service..."
service mysql start

# Wait for MariaDB to fully start
until mysqladmin ping --silent; do
	echo "Waiting for MySQL to start..."
	sleep 1
done

# Create databases if they do not exist
create_database

# Create MySQL user and grant privileges
create_mysql_user

# Check if database needs to be updated
if check_db_update; then
	update_db
else
	echo "No database update performed."
fi

# Start any required services or further initialization here

exec "$@"

