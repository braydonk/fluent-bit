#!/bin/bash
set -e

echo "================================"
echo " Fluent Bit Installation Script "
echo "================================"
echo "This script requires superuser access to install packages."
echo "You will be prompted for your password by sudo."

# Determine package type to install: https://unix.stackexchange.com/a/6348
# OS used by all
# VER only used for RPMs
# CODENAME only used for Debs
if lsb_release &>/dev/null; then
    OS=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    VER=$(lsb_release -rs | tr '[:upper:]' '[:lower:]')
    CODENAME=$(lsb_release -cs)
elif [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    source /etc/os-release
    OS=$( echo "${NAME// /}" | tr '[:upper:]' '[:lower:]')
    # Only want a number
    VER=$( echo "${VERSION_ID%.*}" | tr '[:upper:]' '[:lower:]')
    CODENAME=$( echo "${VERSION_CODENAME}" | tr '[:upper:]' '[:lower:]')
else
    OS=$(uname -s)
fi

# Clear any previous sudo permission
sudo -k

# Now set up repos and install dependent on OS, version, etc.
# Will require sudo
case ${OS} in
    amazonlinux)
        sudo sh <<SCRIPT
rpm --import https://packages.fluentbit.io/fluentbit.key
cat > /etc/yum.repos.d/fluent-bit.repo <<EOF
[fluent-bit]
name = Fluent Bit
baseurl = https://packages.fluentbit.io/amazonlinux/${VER}/\$basearch/
gpgcheck=1
gpgkey=https://packages.fluentbit.io/fluentbit.key
enabled=1
EOF
yum -y install fluent-bit
SCRIPT
    ;;
    centos|centoslinux|redhatenterpriselinuxserver)
        sudo sh <<SCRIPT
rpm --import https://packages.fluentbit.io/fluentbit.key
cat > /etc/yum.repos.d/fluent-bit.repo <<EOF
[fluent-bit]
name = Fluent Bit
baseurl = https://packages.fluentbit.io/centos/${VER}/\$basearch/
gpgcheck=1
gpgkey=https://packages.fluentbit.io/fluentbit.key
enabled=1
EOF
yum -y install fluent-bit
SCRIPT
    ;;
    ubuntu|debian)
        # Remember apt-key add is deprecated
        # https://wiki.debian.org/DebianRepository/UseThirdParty#OpenPGP_Key_distribution
        sudo sh <<SCRIPT
export DEBIAN_FRONTEND=noninteractive
mkdir -p /usr/share/keyrings/
curl https://packages.fluentbit.io/fluentbit.key | gpg --dearmor > /usr/share/keyrings/fluentbit-keyring.gpg
cat > /etc/apt/sources.list.d/fluent-bit.list <<EOF
deb [signed-by=/usr/share/keyrings/fluentbit-keyring.gpg] https://packages.fluentbit.io/${OS}/${CODENAME} ${CODENAME} main
EOF
apt-get -y update
apt-get -y install fluent-bit
SCRIPT
    ;;
    *)
        echo "${OS} not supported."
        exit 1
    ;;
esac

echo ""
echo "Installation completed. Happy Logging!"
echo ""