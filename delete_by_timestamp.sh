#!/bin/bash
set -e

REGISTRY_IMAGE="${1}"

# get date from 28 days ago in Y-m-d format
DATE=$(date -v-28d '+%Y-%m-%d')

# list digests
service_tags=$(gcloud container images list-tags $REGISTRY_IMAGE --sort-by=TIMESTAMP --filter="tags ~ r'*-\d+$' AND timestamp.datetime < '${DATE}'" \
--format='get(digest)' | tr ";" "\n")

# print out
function list(){
    echo "the following images have been idle for more than 28 days, they shall be deleted..."
    for tag in $service_tags; do
        echo $REGISTRY_IMAGE@$tag
    done
    echo "done..."
}

# delete
# be cautious with this one
function drop_from_gcr(){
    echo "deleting from gcr"
    for digest in $service_tags; do
        set -x
        gcloud container images delete -q --force-delete-tags $REGISTRY_IMAGE@$digest
    done
    echo "done deleting from gcr..."
}

list
drop_from_gcr