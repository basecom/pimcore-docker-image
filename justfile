#!/usr/bin/env just --justfile

[private]
default:
    @just --list

# Install orca
install-orca:
	curl -O https://orca-build.io/downloads/orca.zip
	unzip -o orca.zip
	rm -rf orca.zip

# Build images
build-images:
	php orca.phar --directory=.

# Build images with debug enabled
build-images-debug:
	php orca.phar --directory=. --debug