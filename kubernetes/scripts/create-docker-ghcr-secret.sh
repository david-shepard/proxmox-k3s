#!/bin/bash
# creates a kubernetes secret for pulling images from GHCR
# then patches default serviceaccount in current namespace
# requires GITHUB_USER and GITHUB_TOKEN environment variables to be set

set -euo pipefail

if [[ -z "${GITHUB_USER:-}" || -z "${GITHUB_TOKEN:-}" ]]; then
    echo "GITHUB_USER and GITHUB_TOKEN environment variables must be set"
    exit 1
fi

CURRENT_NAMESPACE=$(kubectl config view --minify --output 'jsonpath={..namespace}')

kubectl -n $CURRENT_NAMESPACE create secret docker-registry ghcr-docker-secret \
 --docker-server=https://ghcr.io --docker-username="$GITHUB_USER" \
 --docker-password="$GITHUB_TOKEN" --docker-email=$(git config user.email) \
 --dry-run=server -o yaml > image-secret.yaml

echo -e "Run the following commands to apply the secret and to patch the default serviceaccount in the current namespace: \n"
echo "kubectl -n $CURRENT_NAMESPACE apply -f image-secret.yaml"
echo "kubectl -n $CURRENT_NAMESPACE patch serviceaccount default -p '{\"imagePullSecrets\": [{\"name\": \"ghcr-docker-secret\"}]}'"
