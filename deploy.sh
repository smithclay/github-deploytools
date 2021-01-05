#!/bin/sh

set -eo pipefail

if [ -z "${GITHUB_REPO-}" ]
then
  echo 'Please set the GITHUB_REPO environment variable (i.e. torvalds/linux).'
  exit 1
fi

if [ -z "${GITHUB_TOKEN-}" ]
then
  echo 'Please set the GITHUB_TOKEN environment variable.'
  exit 1
fi

deploy() {
    if [ "$1" = "create" ]; then
        if [ -z "${GITHUB_REF-}" ]
        then
          echo `Please set the GITHUB_REF environment variable.`
          exit 1
        fi


        if [ -z "${LS_SERVICE_NAME-}" ]
        then
          echo 'Please set the LS_SERVICE_NAME environment variable - i.e. frontend'
          exit 1
        fi

        if [ -z "${SERVICE_ENV-}" ]
        then
          echo 'Please set the SERVICE_ENV environment variable - i.e. production, staging, etc.'
          exit 1
        fi

        JSON_PAYLOAD='{"ref": "'$GITHUB_REF'", "environment": "'$SERVICE_ENV'", "description": "Deployment for '$LS_SERVICE_NAME'", "payload": { "service.name": "'$LS_SERVICE_NAME'" } }'
        command jq -n "$JSON_PAYLOAD" | \
          gh api repos/$GITHUB_REPO/deployments \
          -H "Accept: application/vnd.github.ant-man-preview+json" \
          --input - | jq .id
    elif [ "$1" = "update-status" ]; then
        if [ -z "${2-}" ]
        then
          echo 'Please pass a deployment id parameter.'
          exit 1
        fi

        # error, failure, inactive, in_progress, queued, pending, success
        command gh api repos/$GITHUB_REPO/deployments/$2/statuses \
          -H "Accept: application/vnd.github.flash-preview+json" \
          -f state=$3 | jq .state
    elif [ "$1" = "list" ]; then
        command gh api repos/$GITHUB_REPO/deployments
    elif [ "$1" = "delete" ]; then
        if [ -z "${2-}" ]
        then
          echo 'Please pass a deployment id parameter.'
          exit 1
        fi
        command gh api -X DELETE repos/$GITHUB_REPO/deployments/$2
    else
       echo "Invalid arg..."
       echo "usage: $0 [ create | update ]"
    fi
}

deploy "$@"
