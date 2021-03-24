#!/bin/bash

# Initialization
if [[ -z "$AWS_REGION" ]]; then
    echo "Missing AWS region. No deployments will be made."
    exit 1
fi
if [[ -z "$GITHUB_REPOSITORY_SLUG" ]]; then
    echo "Missing GitHub repository slug, e.g. octocat/hello-world. No deployments will be made."
    exit 2
fi
if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" ]]; then
    echo "Missing AWS credentials. No deployments will be made."
    exit 3
fi
if [[ -z "$CLI_REPO_TOKEN" ]]; then
    echo "Missing GitHub credentials for the CLI repository. No deployments will be made."
    exit 4
fi
if [[ -z "HOMEBREW_REPO_TOKEN" ]]; then
    echo "Missing GitHub credentials for the Homebrew repository. No deployments will be made."
    exit 4
fi
if [[ -z "$NPM_AUTH_TOKEN" ]]; then
    echo "Missing NPM credentials. No deployments will be made."
    exit 5
fi

# Get tag information
# PREVIOUS_GIT_TAG=$(git describe --tags --abbrev=0 | sed -e 's/v//') # github is not cooperating with my git command. so read from package.json
VERSION_IN_CHANGELOG=$(node deployment-scripts/get-version.js)

node deployment-scripts/compare-versions.js $VERSION_IN_CHANGELOG #$PREVIOUS_GIT_TAG $VERSION_IN_CHANGELOG

if [[ $? -ne 0 ]]; then
    echo "Version numbers were not valid. No deployments will be made."
    exit 6
fi

# Begin deployment
echo "Starting deployment..."

# Git configuration (adapted from https://gist.github.com/willprice/e07efd73fb7f13f917ea)
config() {
  git config --global user.email "4741599+jblack-vail@users.noreply.github.com"
  git config --global user.name "jblack-vail"
  git remote add origin-cli https://${CLI_REPO_TOKEN}@github.com/${GITHUB_REPOSITORY_SLUG}.git > /dev/null 2>&1
}
config

# Push package to NPM
yarn install --frozen-lockfile --production=false
npm set registry "http://registry.npmjs.org"
npm set //registry.npmjs.org/:_authToken $NPM_AUTH_TOKEN
echo "Logged in to npm as $(npm whoami)"
npm version $VERSION_IN_CHANGELOG
npm publish

# Push tarball to AWS (for Homebrew)
yarn oclif-dev pack
yarn oclif-dev publish

push() {
  git push --quiet --set-upstream origin main
}
push

# Update Homebrew deployment
NEW_SHA=$(shasum -a 256 "dist/freeclimb-v${VERSION_IN_CHANGELOG}.tar.gz")
mkdir homebrew-repo
git clone https://${HOMEBREW_REPO_TOKEN}@github.com/${HOMEBREW_REPOSITORY_SLUG}.git homebrew-repo
cd homebrew-repo
sed -E -i "s/  sha256 \"[a-f0-9]+\"/  sha256 \"$NEW_SHA\"/g" Formula/freeclimb.rb
sed -E -i "s/  url \".+\"/  url \"https://vail-freeclimb-cli-testing.s3.us-east-2.amazonaws.com/freeclimb-v${VERSION_IN_CHANGELOG}/freeclimb-v${VERSION_IN_CHANGELOG}.tar.gz\"/g" Formula/freeclimb.rb
git add .
git commit -m "Update package to version $VERSION_IN_CHANGELOG"
push