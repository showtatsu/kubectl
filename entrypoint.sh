#!/bin/sh

set -e

echo "/usr/local/bin/kubectl" >> $GITHUB_PATH
source /scripts/create-kubeconfig.sh

if [ -n "$script" ]; then
    echo "$script" > /tmp/script.sh
    chmod +x /tmp/script.sh
    cat /tmp/script.sh
    echo "Running script:"
    /tmp/script.sh
elif [ -z "$dest" ]; then
    kubectl $*
else
    EOF=$(dd if=/dev/urandom bs=15 count=1 status=none | base64)
    echo "$dest<<$EOF" >> $GITHUB_ENV
    kubectl $* >> $GITHUB_ENV
    if [[ "${GITHUB_ENV: -1}" != $'\n' ]]; then
        echo >> $GITHUB_ENV
    fi
    echo "$EOF" >> $GITHUB_ENV

    echo "::add-mask::$dest"
fi
