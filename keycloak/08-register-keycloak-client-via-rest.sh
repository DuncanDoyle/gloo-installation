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

################################### Register OIDC Client ###################################

echo "\nCreating new OIDC client in Keycloak."

# Create initial token to register the client. This creates the ClientID.
read -r client token <<<$(curl $CURL_INSECURE -s -H "Authorization: Bearer ${KEYCLOAK_TOKEN}" -X POST -H "Content-Type: application/json" -d '{"expiration": 0, "count": 1}' $KEYCLOAK_URL/admin/realms/master/clients-initial-access | jq -r '[.id, .token] | @tsv')

# Register the client OAuth. Note that this creates the ClientSecret
read -r id secret <<<$(curl $CURL_INSECURE -s -X POST -d "{ \"clientId\": \"${client}\", \"name\": \"solo-io-demo-client\" }" -H "Content-Type:application/json" -H "Authorization: bearer ${token}" ${KEYCLOAK_URL}/realms/master/clients-registrations/default| jq -r '[.id, .secret] | @tsv')

echo "\nRegistered client with the following credentials. Keep these credentials safe!"
echo "ClientID: $client"
echo "ClientSecret: $secret"

# Add allowed redirect URIs
echo "\nConfiguring client redirect URIs."

export REDIRECT_URIS=https://httpbin.solo.io/callback

curl $CURL_INSECURE -H "Authorization: Bearer ${KEYCLOAK_TOKEN}" -X PUT \
  -H "Content-Type: application/json" -d "{\"serviceAccountsEnabled\": true, \"directAccessGrantsEnabled\": true, \"authorizationServicesEnabled\": true, \"redirectUris\": [\"$REDIRECT_URIS\"]}" $KEYCLOAK_URL/admin/realms/master/clients/${id}

################################### Configure Keycloak to include group and subscription attribute in the JWT token ###################################

echo "\nConfiguring JWT token for client."

# Add the group attribute in the JWT token returned by Keycloak
curl $CURL_INSECURE -H "Authorization: Bearer ${KEYCLOAK_TOKEN}" -X POST -H "Content-Type: application/json" -d '{"name": "group", "protocol": "openid-connect", "protocolMapper": "oidc-usermodel-attribute-mapper", "config": {"claim.name": "group", "jsonType.label": "String", "user.attribute": "group", "id.token.claim": "true", "access.token.claim": "true"}}' $KEYCLOAK_URL/admin/realms/master/clients/${id}/protocol-mappers/models

# Add the subscription attribute in the JWT token returned by Keycloak
curl $CURL_INSECURE -H "Authorization: Bearer ${KEYCLOAK_TOKEN}" -X POST -H "Content-Type: application/json" -d '{"name": "subscription", "protocol": "openid-connect", "protocolMapper": "oidc-usermodel-attribute-mapper", "config": {"claim.name": "subscription", "jsonType.label": "String", "user.attribute": "subscription", "id.token.claim": "true", "access.token.claim": "true"}}' $KEYCLOAK_URL/admin/realms/master/clients/${id}/protocol-mappers/models