#!/bin/sh
#########################################################
#                                                       #
#   Name: Cert Generator                                #
#   Author: Diego Castagna (diegocastagna.com)          #
#   Description: This script will create                #
#   a Cert private Key and it's Certificate             #
#   License: diegocastagna.com/license                  #
#                                                       #
#########################################################

# Variables
domain="${1}"
CAPrivate="${2}"
CACert="${3}"

# Performing some checks
if [ $(id -u) -ne 0 ]; then
    echo "This script must be run as root or with sudo privileges"
    exit 1
fi
if [ $# -le 2 ]; then
    echo "Usage: ${0} Domain CAPrivateKey CACertificate"
    exit 1
fi

# Certificate Private Key
openssl genrsa -out $domain.key 4096

# Certificate Request
openssl req -new -key $domain.key -out $domain.csr

echo "authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = %%$domain%%" > $domain.ext

# Creating the certificate
openssl x509 -req -in $domain.csr -CA $CACert -CAkey $CAPrivate -CAcreateserial -out $domain.pem -days 1825 -sha256 -extfile $domain.ext