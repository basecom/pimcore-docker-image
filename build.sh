#!/usr/bin/env bash
set -Eeuo pipefail

./build/php/build-php-images.sh

# Write includes.yaml file for gitlab-ci
cd ./gitlab-ci

includes="include:
"

for filename in *.yaml; do
    if [ $filename == 'includes.yaml' ]; then
        continue
    fi

    includes+="    - local: /gitlab-ci/$filename
"
done

echo "$includes" > includes.yaml

cd ../
