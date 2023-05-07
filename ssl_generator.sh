!/bin/bash

ROOT_CA_COMMON_NAME="Root CA"
ROOT_CA_CERT_VALIDITY_IN_DAYS=3650
ROOT_CA_KEY_PASS=changeit

SERVER_COMMON_NAME=myserver.com
SERVER_CERT_VALIDITY_IN_DAYS=730
SERVER_KEY_PASS=changeit

#This script requires keytool and openssl commands.

#generate root ca private key, public key and certificate (in PFX format)
keytool -genkeypair -alias rootca -dname "cn=$ROOT_CA_COMMON_NAME" -validity $ROOT_CA_CERT_VALIDITY_IN_DAYS -keyalg RSA -keysize 2048 -ext bc:c -keystore rootca.pfx -keypass $ROOT_CA_KEY_PASS -storepass $ROOT_CA_KEY_PASS -deststoretype pkcs12

#generate server keypair
keytool -genkeypair -alias server -dname "cn=$SERVER_COMMON_NAME" -validity $SERVER_CERT_VALIDITY_IN_DAYS -keyalg RSA -keysize 2048 -keystore server.pfx -keypass $SERVER_KEY_PASS -storepass $SERVER_KEY_PASS -deststoretype pkcs12

#generate server CSR and issue server cert by root ca
keytool -keystore server.pfx -storepass $SERVER_KEY_PASS -certreq -alias server | keytool -keystore rootca.pfx -storepass $ROOT_CA_KEY_PASS -gencert -validity $SERVER_CERT_VALIDITY_IN_DAYS -alias rootca -ext ku:c=dig,keyEnc -ext "san=dns:$SERVER_COMMON_NAME" -ext eku=sa,ca -rfc > server-cert.pem

#export root ca cert from PFX
keytool -exportcert -keystore rootca.pfx -alias rootca -storepass $ROOT_CA_KEY_PASS -rfc > rootca-cert.pem

#import root ca certificate into server keystore
keytool -importcert -keystore server.pfx -storepass $ROOT_CA_KEY_PASS -file rootca-cert.pem

#import generated server.pem into server keystore
keytool -importcert -keystore server.pfx -storepass $SERVER_KEY_PASS -file server-cert.pem -alias server

#export ca key from PFX
openssl pkcs12 -in rootca.pfx -nodes -nocerts -out rootca-key.pem -passin pass:$ROOT_CA_KEY_PASS

#export server key from PFX
openssl pkcs12 -in server.pfx -nodes -nocerts -out server-key.pem -passin pass:$SERVER_KEY_PASS


#############################
#Commands to see the contents
#############################
# To view contents of PKCS12
#keytool -keystore rootca.jks -list -v 

#to view contents of cert
#openssl x509 -in rootca.pem -text
