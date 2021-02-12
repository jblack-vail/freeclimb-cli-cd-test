#!/bin/bash

# Initialization
if [[ "$UPDATE_TYPE" == "major" || "$UPDATE_TYPE" == "minor" || "$UPDATE_TYPE" == "patch" ]]; then
    if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" ]]; then
        echo "Missing AWS credentials. No deployments will be made."
        exit 1
    else
        if [[ -z "$GITHUB_AUTH_TOKEN" ]]; then
            echo "Missing GitHub credentials. No deployments will be made."
            exit 2
        else
            if [[ -z "$NPM_AUTH_TOKEN" ]]; then
                echo "Missing NPM credentials. No deployments will be made."
                exit 3
            fi
        fi
    fi
else
    echo "Missing a valid update type. No deployments will be made."
    exit 4
fi

echo "Starting deployment"

# Push package to NPM
echo "//registry.npmjs.org/:_authToken=$NPM_AUTH_TOKEN" > ~/.npmrc
echo "Logged in to npm as $(npm whoami)"
npm version $UPDATE_TYPE
npm publish

# Push tarball to AWS (for Homebrew)
yarn oclif-dev pack
yarn oclif-dev publish

# Git commit (adapted from https://gist.github.com/willprice/e07efd73fb7f13f917ea)
config() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
  git remote add origin-pages https://${GITHUB_AUTH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git > /dev/null 2>&1
}
commit() {
  git add .
  git commit --message "Deployed by Travis CI. Build number: $TRAVIS_BUILD_NUMBER"
}
push() {
  git push
}
config
commit
push