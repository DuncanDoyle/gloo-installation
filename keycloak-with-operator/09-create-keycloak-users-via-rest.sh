#!/bin/sh

export CURL_INSECURE="--insecure"
export KEYCLOAK_URL=https://keycloak.example.com
export KEYCLOAK_ENDPOINT=$KEYCLOAK_URL

# This does not work for https, we would probably use curl against the REST API.
#echo "Waiting for Keycloak to become available."
# timeout 60 bash -c "while ! echo exit | nc $KEYCLOAK_ENDPOINT 443 > /dev/null; do printf '.'; sleep 1; done"
timeout 60 bash -c "while ! echo exit | curl -s $CURL_INSECURE https://keycloak.example.com/realms/master > /dev/null; do printf '.'; sleep 1; done"

# Using "--insecure" to accept the self-signed certificate we're using for HTTPS. Loging in with username "admin" and password "admin":
export KEYCLOAK_TOKEN=$(curl $CURL_INSECURE -s -d "client_id=admin-cli" -d "username=admin" -d "password=admin" -d "grant_type=password" "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" | jq -r .access_token)

echo "Keycloak token: $KEYCLOAK_TOKEN"

################################### Register Users ###################################

echo "\nCreating demo users."

# Create regular user for ACME Corp.
curl $CURL_INSECURE -H "Authorization: Bearer ${KEYCLOAK_TOKEN}" -X POST -H "Content-Type: application/json" -d '{"username": "user1", "email": "user1@acme.com", "enabled": true, "attributes": {"group": "users", "subscription": "enterprise"}, "credentials": [{"type": "password", "value": "password", "temporary": false}]}' $KEYCLOAK_URL/admin/realms/master/users

# Create regular user for Umbrella Corp.
curl $CURL_INSECURE -H "Authorization: Bearer ${KEYCLOAK_TOKEN}" -X POST -H "Content-Type: application/json" -d '{"username": "user2", "email": "user2@umbrella.com", "enabled": true, "attributes": {"group": "users", "subscription": "free"}, "credentials": [{"type": "password", "value": "password", "temporary": false}]}' $KEYCLOAK_URL/admin/realms/master/users

# Create admin user
curl $CURL_INSECURE -H "Authorization: Bearer ${KEYCLOAK_TOKEN}" -X POST -H "Content-Type: application/json" -d '{"username": "admin1", "email": "admin1@solo.io", "enabled": true, "attributes": {"group": "admin"}, "credentials": [{"type": "password", "value": "password", "temporary": false}]}' $KEYCLOAK_URL/admin/realms/master/users
