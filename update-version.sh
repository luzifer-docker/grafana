#!/bin/bash

set -e
set -o pipefail

HOST_OS=$(uname -s)

### ---- ###

echo "Switch back to master"
git checkout master
git reset --hard origin/master

### ---- ###

echo "Fetching latest version..."
LATEST=$(curl -sSLf 'https://latest.luzifer.io/catalog-api/grafana/latest.txt?p=version')

echo "Testing presence of build artifact for ${LATEST}..."
curl -sSILf https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_${LATEST}_amd64.deb

echo "Found version ${LATEST}, patching..."
sed -i "s/^ENV GRAFANA_VERSION.*$/ENV GRAFANA_VERSION ${LATEST}/" Dockerfile

echo "Checking for changes..."
git diff --exit-code && exit 0

echo "Testing build..."
docker build .

echo "Updating repository..."
git add Dockerfile
git -c user.name='Travis Automated Update' -c user.email='travis@luzifer.io' \
  commit -m "Jenkins ${LATEST}"
git tag ${LATEST}

git push -q https://${GH_USER}:${GH_TOKEN}@github.com/luzifer-docker/grafana.git master --tags
