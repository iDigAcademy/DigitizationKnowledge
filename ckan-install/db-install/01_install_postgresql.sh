#!/bin/bash

# Check if PostgreSQL is already installed
if psql --version &> /dev/null; then
	echo "PostgreSQL is already installed. Version: $(psql --version)"
else
	echo "PostgreSQL is being installed."

	# Install PostgreSQL repository and package
	sudo apt update
	sudo apt install -y curl ca-certificates
	sudo apt install -d /usr/share/postgresql-common/pgdg
	sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
	sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
	sudo apt update
	sudo apt -y install postgresql-17
fi


# Ask if the user wants to alter the password for the postgres user
read -p "Do you want to alter the password for the postgres user? (yes/no): " alter_password_choice
if [[ "$alter_password_choice" == "yes" ]]; then
	# Prompt for the new password
	read -s -p "Enter the new password for the postgres user: " new_password
	echo ""
	read -s -p "Confirm the new password: " confirm_password
	echo ""

	# Check if the passwords match
	if [[ "$new_password" == "$confirm_password" ]]; then
		# Alter the password for the postgres user
		sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$new_password';"
		echo "Password for the postgres user has been updated successfully."
	else
		echo "Passwords do not match. Exiting."
		exit 1
	fi
else
	echo "No changes made to the postgres user password. Exiting."
	exit 0
fi