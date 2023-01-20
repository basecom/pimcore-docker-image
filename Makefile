install-orca:
	curl -O https://orca-build.io/downloads/orca.zip
	unzip -o orca.zip
	rm -rf orca.zip

build-images:
	php orca.phar --directory=.

build-images-debug:
	php orca.phar --directory=. --debug