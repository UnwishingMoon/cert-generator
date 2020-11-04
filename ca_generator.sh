#!/bin/sh
#########################################################
#                                                       #
#   Name: CA Generator                                  #
#   Author: Diego Castagna (diegocastagna.com)          #
#   Description: This script will create                #
#   a CA private key and it's Certificate               #
#   License: diegocastagna.com/license                  #
#                                                       #
#########################################################

# Variables
CAName="${1}"
passPhrase="${2}"

# Performing some checks
if [[ $EUID -ne 0 ]]; then
    echo "[CA_GENERATOR] This script must be run as root or with sudo privileges"
    exit 1
fi
if [ $# -le 0 ]; then
    echo "Usage: ${0} CAName"
    exit 1
fi

# CA Root Private Key
openssl genrsa -des3 -out CA_$CAName.key 4096
# CA Certificate
openssl req -x509 -new -nodes -key CA_$CAName.key -sha256 -days 7300 -out CA_$CAName.pem