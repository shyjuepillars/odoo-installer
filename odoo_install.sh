#!/bin/bash

# =====================================================================
# CONFIGURATION DEFAULTS (Change these anytime)
# =====================================================================
DEFAULT_PATH="$HOME/odoo"
DEFAULT_VERSION="18.0"
# =====================================================================

# --- 1. Path Selection Logic ---
if [ -n "$1" ]; then
    INSTALL_PATH="$1"
else
    read -p "Enter Odoo installation path [Default: $DEFAULT_PATH]: " INPUT_PATH
    INSTALL_PATH="${INPUT_PATH:-$DEFAULT_PATH}"
fi

# Convert relative paths (like ~ or .) to absolute paths
INSTALL_PATH=$(eval echo "$INSTALL_PATH")


# --- 2. Version Selection Logic ---
if [ -n "$2" ]; then
    ODOO_VERSION="$2"
else
    read -p "Enter Odoo version (e.g., 15.0, 16.0, 17.0, 18.0) [Default: $DEFAULT_VERSION]: " INPUT_VERSION
    ODOO_VERSION="${INPUT_VERSION:-$DEFAULT_VERSION}"
fi

echo "-----------------------------------------"
echo "Installation Path: $INSTALL_PATH"
echo "Odoo Version:      $ODOO_VERSION"
echo "PostgreSQL User:   $USER (Passwordless Peer Authentication)"
echo "-----------------------------------------"

# Update and Upgrade system
sudo apt update && sudo apt full-upgrade -y

# Install required basic tools
sudo apt install -y build-essential python3-dev python3-venv python3-pip \
    git curl wget libxslt-dev libzip-dev libldap2-dev libsasl2-dev \
    libjpeg-dev libpq-dev gcc g++ libffi-dev libxml2-dev zlib1g-dev \
    libssl-dev libjpeg8-dev liblcms2-dev libblas-dev libatlas-base-dev python3-venv

# Install PostgreSQL
sudo apt install -y postgresql
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Install Node.js 18 and LESS compiler
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g less less-plugin-clean-css

# Install wkhtmltopdf (for PDF reports)
sudo apt install -y wkhtmltopdf

# Create Odoo directory and navigate to it
sudo mkdir -p "$INSTALL_PATH"
sudo chown -R $USER:$USER "$INSTALL_PATH"
cd "$INSTALL_PATH"

# Clone selected Odoo version
echo "Cloning Odoo version $ODOO_VERSION..."
git clone https://github.com/odoo/odoo --depth 1 --branch "$ODOO_VERSION" "$INSTALL_PATH/odoo-server"

# Create Python virtual environment
python3 -m venv "$INSTALL_PATH/venv"
source "$INSTALL_PATH/venv/bin/activate"

# Install Python dependencies
pip install wheel
pip install -r "$INSTALL_PATH/odoo-server/requirements.txt"

# Create PostgreSQL User matching your current Linux system user
sudo -u postgres createuser --createdb --username postgres --no-createrole --no-superuser "$USER" 2>/dev/null || echo "PostgreSQL user '$USER' already exists."

# Create custom_addons directory
mkdir -p "$INSTALL_PATH/custom_addons"

# Create Odoo configuration file
tee "$INSTALL_PATH/odoo.conf" <<EOL
[options]
admin_passwd = admin
db_host = False
db_port = False
db_user = $USER
addons_path = $INSTALL_PATH/odoo-server/addons,$INSTALL_PATH/custom_addons
; logfile = /var/log/odoo/odoo.log
EOL

# Done
echo "-------------------------------------------------------------"
echo "Odoo $ODOO_VERSION installation finished!"
echo "To start Odoo, run the following commands:"
echo "-------------------------------------------------------------"
echo "source $INSTALL_PATH/venv/bin/activate"
echo "$INSTALL_PATH/odoo-server/odoo-bin -c $INSTALL_PATH/odoo.conf"
echo "-------------------------------------------------------------"
