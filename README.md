# Odoo Installer

A comprehensive bash script to automate the installation and setup of Odoo on Ubuntu/Debian systems.

## Features

- **Automated System Setup**: Installs all required system dependencies and development tools
- **PostgreSQL Integration**: Sets up PostgreSQL with passwordless peer authentication
- **Python Virtual Environment**: Creates isolated Python environment for Odoo
- **Node.js & LESS**: Installs Node.js 18 and LESS compiler for asset compilation
- **Custom Addons Support**: Creates directory structure for custom Odoo modules
- **Configuration Management**: Generates ready-to-use Odoo configuration file
- **Flexible Installation**: Supports custom installation paths and Odoo versions

## Prerequisites

- Ubuntu 20.04 LTS or later (or compatible Debian-based system)
- `sudo` privileges
- Minimum 2GB RAM (4GB+ recommended)
- Minimum 5GB free disk space

## Installation & Usage

### Quick Start

Run the script with default settings (installs to `~/odoo` with Odoo 18.0):

```bash
bash odoo_install.sh
```

### Custom Installation Path

```bash
bash odoo_install.sh /path/to/odoo
```

### Custom Version

```bash
bash odoo_install.sh /path/to/odoo 17.0
```

Both parameters together:

```bash
bash odoo_install.sh /opt/odoo 16.0
```

### Interactive Mode

If you run the script without arguments, you'll be prompted to enter:
1. Installation path (defaults to `~/odoo`)
2. Odoo version (defaults to `18.0`)

Supported versions: 15.0, 16.0, 17.0, 18.0, and later

## What the Script Does

1. **System Update**: Updates and upgrades system packages
2. **Install Dependencies**:
   - Build tools (build-essential, gcc, g++)
   - Python development libraries and pip
   - Required development libraries (libxslt, libzip, libldap, libjpeg, etc.)
3. **Database Setup**: Installs and configures PostgreSQL
4. **Node.js Installation**: Sets up Node.js 18 and LESS compiler
5. **PDF Support**: Installs wkhtmltopdf for PDF report generation
6. **Odoo Repository**: Clones the specified Odoo version from GitHub
7. **Python Environment**: Creates virtual environment and installs dependencies
8. **Database User**: Creates PostgreSQL user matching your Linux username
9. **Configuration**: Generates `odoo.conf` with basic settings

## Starting Odoo

After installation completes, the script will display commands to start Odoo:

```bash
cd /path/to/odoo
source venv/bin/activate
/path/to/odoo/odoo-server/odoo-bin -c /path/to/odoo/odoo.conf
```

Then access Odoo at: `http://localhost:8069`

## Configuration

The installation creates `odoo.conf` in your installation directory. Key settings:

- **admin_passwd**: Default admin password (change after first login)
- **db_host/db_port**: Local database connection
- **db_user**: PostgreSQL user (matches your Linux username)
- **addons_path**: Includes both core and custom addons directories

For more configuration options, see the [Odoo documentation](https://www.odoo.com/documentation/18.0/administration/odoo_server/configuration.html).

## File Structure

After installation, your directory will look like:

```
/path/to/odoo/
├── odoo-server/          # Odoo source code
├── venv/                 # Python virtual environment
├── custom_addons/        # Your custom modules
└── odoo.conf            # Odoo configuration file
```

## Troubleshooting

### PostgreSQL User Already Exists

If you see "PostgreSQL user already exists", the script will continue without errors. You can proceed normally.

### Permission Errors

If you encounter permission errors, ensure you have `sudo` access and the installation directory is writable.

### Port Already in Use

By default, Odoo runs on port 8069. If this port is in use, specify a different port:

```bash
/path/to/odoo/odoo-server/odoo-bin -c /path/to/odoo/odoo.conf --http-port 8070
```

### Missing Dependencies

If you encounter missing library errors, run the script again or manually install missing packages with `apt`.

## Requirements Summary

The script installs the following key components:

- **System**: build-essential, python3-dev, python3-venv, git, curl, wget
- **Libraries**: libxslt, libzip, libldap, libsasl2, libjpeg, libpq, libffi, libxml2, zlib1g, libssl
- **Database**: PostgreSQL
- **Runtime**: Python 3, Node.js 18, LESS compiler
- **Utilities**: wkhtmltopdf

## License

This script is provided as-is for installing Odoo. Odoo itself is licensed under the AGPL-3.0 License. See [Odoo License](https://github.com/odoo/odoo/blob/master/LICENSE) for details.

## Support & Contributions

For issues with the installation script, please check the troubleshooting section or review the script comments for more details on each step.

To report issues or suggest improvements, please open an issue or pull request in the repository.

---

**Note**: This script is designed for development and testing environments. For production deployments, consider using Docker, Odoo's official hosting, or consulting the [Odoo Implementation Guide](https://www.odoo.com/documentation).
