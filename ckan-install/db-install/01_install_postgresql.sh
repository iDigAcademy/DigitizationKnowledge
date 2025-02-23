#!/bin/bash

# Check if PostgreSQL is already installed
if psql --version &> /dev/null; then
	echo "PostgreSQL is already installed. Version: $(psql --version)"
else
	echo "PostgreSQL is being installed."

	sudo apt update && sudo apt upgrade -y
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/pgdg.asc &>/dev/null
    sudo apt update -y
    sudo apt install postgresql-17 postgresql-client-17 -y
    sudo systemctl enable postgresql
    sudo systemctl start postgresql
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