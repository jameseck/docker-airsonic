#!/bin/sh
set -e

# Latest release
URL=$(curl -s https://api.github.com/repos/Airsonic/Airsonic/releases | jq -r "[ .[] | .assets[] | select(.name | test(\"airsonic.war\")) ] | first | .browser_download_url")
VERSION=$(echo $URL | cut -d\/ -f8)

git pull > /dev/null 2>&1
DOCKERFILE_VERSION=$(grep "^ARG AIRSONIC_VERSION=" Dockerfile | cut -f2 -d\=)

if [ "${VERSION}" != "${DOCKERFILE_VERSION}" ]; then
  echo "Updating Dockerfile with version ${VERSION}"
  sed -i -e "s/^\(ARG AIRSONIC_VERSION=\).*$/\1${VERSION}/g" \
         -e "s|^\(ARG AIRSONIC_URL=\).*$|\1${URL}|g" Dockerfile
  git add Dockerfile
  git commit -m "Bumping Airsonic version to ${VERSION}"
  git push
  make minor-release
  exit -1
else
  make build
  make push
  echo "No change"
fi

# exit codes:
# 0 - no action
# -1 - new build pushed
# rest - errors
