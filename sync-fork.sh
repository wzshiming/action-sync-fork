#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

REPOSITORY="${1:-${REPOSITORY}}"

if [[ "${REPOSITORY}" == "" ]]; then
    echo "REPOSITORY is required"
    exit 1
fi

function default_branch() {
  local repo=${1}
  gh repo view "${repo}" --json defaultBranchRef --jq .defaultBranchRef.name
}

function sync_fork() {
  local repo=${1}
  gh api --method POST -H "Accept: application/vnd.github+json" "/repos/${repo}/merge-upstream" -f branch="$(default_branch "${repo}")" --jq '.' | cat
}

sync_fork "${REPOSITORY}"
