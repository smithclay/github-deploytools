#!/bin/sh

set -eo pipefail

if [ -z "${GITHUB_REPO-}" ]
then
  echo 'Please set the GITHUB_REPO environment variable (i.e. torvalds/linux).'
  exit
fi

if [ -z "${GITHUB_TOKEN-}" ]
then
  echo Please set the GITHUB_TOKEN environment variable.
  exit
fi

deploy() {
    if [ "$1" = "create" ]; then
        if [ -z "${GITHUB_REF-}" ]
        then
          echo Please set the GITHUB_REF environment variable.
          exit
        fi

        if [ -z "${SERVICE_ENV-}" ]
        then
          echo 'Please set the SERVICE_ENV environment variable - i.e. production, staging, etc.'
          exit
        fi

        command gh api repos/$GITHUB_REPO/deployments \
          -H "Accept: application/vnd.github.ant-man-preview+json" \
          -f ref=$GITHUB_REF -f environment=$SERVICE_ENV | jq .id
    elif [ "$1" = "update-status" ]; then
        # error, failure, inactive, in_progress, queued, pending, success
        command gh api repos/$GITHUB_REPO/deployments/$2/statuses \
          -H "Accept: application/vnd.github.flash-preview+json" \
          -f state=$3 | jq .state
    else
       echo "Invalid arg..."
       echo "usage: $0 [ create | update ]"
    fi
}

deploy "$@"
