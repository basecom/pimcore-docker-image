Images
======

This Repository provides basic PHP Service Images which can be used as a base
for project specific service images, so the extension installation does not need to be copied into
multiple docker files

## Systems

- Pimcore

## Provided Images Types

- PHP CLI
- PHP FPM

## Provided PHP versions

- 8.0
- 8.1
- 8.2
- 8.3
- 8.4

## Provided Tags

- PHPVERSION-IMAGETYPE-bullseye-SYSTEM

## Create and build new images

* Create your desired version in `variants/php/8.x` and copy the `cli` and `fpm` from another version
* Adjust the `variables.json` files to your needs
* Add the new version to the `manifest.json` file
* Run `just install-orca` to install orca
* Run `just build-images` to build your images with orca
  * For that you need `php` installed locally
