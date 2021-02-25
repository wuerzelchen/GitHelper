#!/bin/bash -eu
#
# Clones (if not present) or pulls all GHE repositories
#
# Example usage:
# alias ghe-fa=path_to/fetch_all.sh
# mkdir org && cd org && ghe-fa
#

# Path to GHE authentication cookies file to access REST API
[[ -z ${GHE_ACCESS_TOKEN:-} ]] && ( echo "GHE_ACCESS_TOKEN should be set"; exit -1; );

# GitHub Enteprise Organization
[[ -z ${GHE_ORGANIZATION:-} ]] && ( echo "GHE_ORGANIZATION should be set"; exit -1; );

# GitHub Enterprise base URL
[[ -z ${GHE_URL:-} ]] && ( echo "GHE_URL should be set"; exit -1; );

function fetch_all() {(
    local cnt=0;
    local api_url=${GHE_URL}/api/v3/orgs/${GHE_ORGANIZATION}
    for page in `seq 1 5`; do
        while read -r repo; do
            [[ ! -z "${repo}" ]] || continue;
            repo_dir=$(basename $repo);
            cnt=$((${cnt}+1));
            printf "%3d " $cnt;
            [[ -d $(basename $repo) ]] && (
                echo "Updating ${repo_dir}... ";
                cd ${repo_dir};
                git pull --quiet --rebase;
            ) || (
                echo "Cloning ${repo_dir}... ";
                git clone --quiet ${repo} ${repo_dir};
            );
        done <<< "$(curl -sS -n -H "User-Agent: git/2.28.0" -b ${GHE_ACCESS_TOKEN} -L "${api_url}/repos?per_page=100&page=${page}" | jq -r '.[].svn_url')" ;
    done;
    echo "Total ${cnt} repos";
)}

_main() {
    local source_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

    mkdir -p ${GHE_ORGANIZATION} && cd ${GHE_ORGANIZATION}
    fetch_all
}

_main "${@:-}"
