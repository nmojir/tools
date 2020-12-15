#!/bin/bash

#usage: ./create_ovpn_user.sh username

cd /usr/share/easy-rsa/3/
./easyrsa build-client-full $1
cd

echo "
client
dev tun
proto udp
remote 5.9.226.22 1194
resolv-retry infinite
nobind
persist-key
persist-tun
comp-lzo
verb 3
cipher AES-128-CBC
auth SHA256
<ca>" > $1.ovpn

cat /usr/share/easy-rsa/3/pki/ca.crt >> $1.ovpn

echo "</ca>
<cert>" >> $1.ovpn

openssl x509 -in /usr/share/easy-rsa/3/pki/issued/$1.crt >> $1.ovpn

echo "</cert>" >> $1.ovpn

echo "<key>" >> $1.ovpn

cat /usr/share/easy-rsa/3/pki/private/$1.key >> $1.ovpn

echo "</key>" >> $1.ovpn
