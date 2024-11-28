#!/bin/bash
set -e
set -x

# Ensure the required tools are installed

# Check if the CUPS admin user exists, if not, create it
if ! id -u "$CUPS_USER_ADMIN" &>/dev/null; then
    echo "Creating CUPS admin user: $CUPS_USER_ADMIN"
    useradd $CUPS_USER_ADMIN --system -G root,lpadmin --no-create-home --password $(echo $CUPS_USER_PASSWORD | mkpasswd -s)
fi

# Start the CUPS service
echo "Starting CUPS server"
exec /usr/sbin/cupsd -f
