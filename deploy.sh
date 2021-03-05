#!/bin/bash

# Initialization
if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" ]]; then
    echo "Missing AWS credentials. No deployments will be made."
    exit 1
else
    if [[ -z "$PERSONAL_ACCESS_TOKEN" ]]; then
        echo "Missing GitHub credentials. No deployments will be made."
        exit 2
    else
        if [[ -z "$NPM_AUTH_TOKEN" ]]; then
            echo "Missing NPM credentials. No deployments will be made."
            exit 3
        fi
    fi
fi

echo "Starting deployment..."

# Get tag information
PREVIOUS_GIT_TAG=${$(git describe --tags --abbrev=0)#v} # removes the 'v' at the beginning of the tag, e.g. v1.2.3 -> 1.2.3
VERSION_IN_CHANGELOG=$(node get-version.js)

node compare-versions.js $PREVIOUS_GIT_TAG $VERSION_IN_CHANGELOG

if [[ $? -ne 0 ]]; then
    echo "Version numbers were not valid. No deployments will be made."
    exit 4
fi

# Push package to NPM
yarn install --production=false
npm set registry "http://registry.npmjs.org"
npm set //registry.npmjs.org/:_authToken $NPM_AUTH_TOKEN
echo "Logged in to npm as $(npm whoami)"
npm version $VERSION_IN_CHANGELOG
npm publish

# Push tarball to AWS (for Homebrew)
yarn oclif-dev pack
yarn oclif-dev publish

# TODO commands to update version number and SHA in external homebrew repository

# Git commit (adapted from https://gist.github.com/willprice/e07efd73fb7f13f917ea)
config() {
  git config --global user.email "4741599+jblack-vail@users.noreply.github.com"
  git config --global user.name "jblack-vail"
  git remote add origin-cli https://${PERSONAL_ACCESS_TOKEN}@github.com/${GITHUB_REPOSITORY_SLUG}.git > /dev/null 2>&1
}
commit() {
  git checkout main
  git add .
  git commit --message "Deployed by GitHub Actions. Updated from $PREVIOUS_GIT_TAG to $VERSION_IN_CHANGELOG"
}
push() {
  git push --quiet --set-upstream origin-cli main
}
config
commit
push