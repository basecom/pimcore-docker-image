#!/usr/bin/env bash
set -Eeuo pipefail

buildDir=build/php

for system in pimcore; do
    baseDockerfile="$buildDir/Dockerfile.template"

    for version in 8.1; do
        for variant in cli fpm; do
            for distribution in bullseye; do
                # Create folder if not exists
                mkdir -p "$buildDir/$version/$variant/$system"

                # Copy base Dockerfile to folder
                cp $baseDockerfile "$buildDir/$version/$variant/$system/Dockerfile"

                # Set PHP-Version, Image variant and distribution
                sed -ri '' -e 's!%%PHP_VERSION%%!'"$version"'!' "$buildDir/$version/$variant/$system/Dockerfile"
                sed -ri '' -e 's!%%IMAGE_VARIANT%%!'"$variant"'!' "$buildDir/$version/$variant/$system/Dockerfile"
                sed -ri '' -e 's!%%DISTRIBUTION%%!'"$distribution"'!' "$buildDir/$version/$variant/$system/Dockerfile"

                # Set system extensions
                path="blocks/php/$system/$version/system-extensions"

                if [ ! -f $path ]; then
                    path="blocks/php/$system/general/system-extensions"
                fi

                gawk -i inplace '/###system-extensions###/ { system("cat '"$path"'") } \
                 !/###system-extensions###/ { print; }' "$buildDir/$version/$variant/$system/Dockerfile"

                # Set php extensions
                path="blocks/php/$system/$version/php-extensions"

                if [ ! -f $path ]; then
                    path="blocks/php/$system/general/php-extensions"
                fi

                gawk -i inplace '/###php-extensions###/ { system("cat '"$path"'") } \
                 !/###php-extensions###/ { print; }' "$buildDir/$version/$variant/$system/Dockerfile"

                # Set additional-packages
                path="blocks/php/$system/$version/additional-packages"

                if [ ! -f $path ]; then
                    path="blocks/php/$system/general/additional-packages"
                fi

                gawk -i inplace '/###additional-packages###/ { system("cat '"$path"'") } \
                 !/###additional-packages###/ { print; }' "$buildDir/$version/$variant/$system/Dockerfile"

                # Set special system extensions
                path="blocks/php/$system/$version/$variant-system-extensions"

                if [ ! -f $path ]; then
                    path="blocks/php/$system/general/$variant-system-extensions"
                fi

                if [ -f $path ]; then
                    gawk -i inplace '/###special-system-extensions###/ { system("cat '"$path"'") } \
                     !/###special-system-extensions###/ { print; }' "$buildDir/$version/$variant/$system/Dockerfile"
                fi

                # Add gitlab-ci job code
                echo "# $system php $version $variant
build $system php-$version-$variant amd:
    extends: .build image
    variables:
        IMAGE_NAME: php
        IMAGE_TAG: $version-$variant-$system
        PHP_VERSION: '$version'
        IMAGE_VARIANT: $variant
        SYSTEM: $system
        PLATFORM: linux/amd64
        ARCH: amd

build $system php-$version-$variant arm:
    extends: .build image
    tags:
         - 'bsc-eks-arm64'
    variables:
        IMAGE_NAME: php
        IMAGE_TAG: $version-$variant-$system
        PHP_VERSION: '$version'
        IMAGE_VARIANT: $variant
        SYSTEM: $system
        PLATFORM: linux/arm64/v8
        ARCH: arm

publish $system php-$version-$variant:
    extends: .publish image
    variables:
        IMAGE_NAME: php
        IMAGE_TAG: $version-$variant-$system
    needs:
        - build $system php-$version-$variant amd
        - build $system php-$version-$variant arm" > gitlab-ci/$system-php-$version-$variant.yaml
            done;
        done;
    done;
done;
