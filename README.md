## Docker link

Hosted on Docker Hub as [uwischool/php-fpm](https://hub.docker.com/r/uwischool/php-fpm/)

## Supported tags and respective Dockerfile links

* [`latest`, `8.1`](docker-php-fpm/blob/main/8.1/default/Dockerfile) [`8.1-imagick`](docker-php-fpm/blob/main/8.1/imagick/Dockerfile) 
* [`8.0`](docker-php-fpm/blob/main/8.0/default/Dockerfile) [`8.0-imagick`](docker-php-fpm/blob/main/8.0/imagick/Dockerfile) 
* [`7.4`](docker-php-fpm/blob/main/7.4/default/Dockerfile) [`7.4-imagick`](docker-php-fpm/blob/main/7.4/imagick/Dockerfile) 
* [`7.2`](docker-php-fpm/blob/main/7.2/default/Dockerfile) [`7.2-mcrypt`](docker-php-fpm/blob/main/7.2/mcrypt/Dockerfile) 
* [`5.6`](docker-php-fpm/blob/main/5.6/default/Dockerfile) 


## Description

Adds PHP modules required to run most Laravel applications. 

Built from official PHP-FPM image on Alpine Linux. Adds the following PHP Modules to the base PHP image:

`gd`, `pdo_dblib`, `pdo_mysql`, `pdo_odbc`, `pcntl`, `zip`

Images with the `-imagick` suffix also add imagick

The image with the `-mcrypt` suffix adds old mcypt support to newer versions of PHP. This is a temporary fix for older projects that require(d) it.


## GitHub workflow/actions schema

Inside `.github/workflow/docker-image.yml` we define a workflow for building docker images. Image builds are triggered when a git repo tag starting with `v` is pushed to github. 

Tagging follows the following format:

`v8.1.0-suffix` 

`8.1` represents the `major.minor` PHP version. `.0` is our build, it increments from 0 to N. The `-suffix` is optional. This allows us to easily support variants of our PHP image, such as the imagick variant. The main purpose of this is to keep our images clean, simple, and as small as possible for a given project.

The build workflow chooses which `Dockerfile` to use based on the above tag. For example, `v8.0.25-imagick` will build `8.0/imagick/Dockerfile` and push it to Dockerhub with the tags `8.0-imagick` and `8.0.25-imagick`

Similarly the git tag `v8.1.14` will build `8.1/default/Dockerfile` with the tags `8.1`, `8.1.14`, and `latest`. `latest` is added if the `major.minor` matches the primary branch on GitHub (current `8.1.x`)


## How to work on and maintain these Docker images

If changes are needed to our docker image, clone this repo and edit the Dockerfile(s) and various associated configs for the version(s) you want to update. Commit your changes to the primary branch, then tag using the schema above. Once you push your tag GitHub actions will build the image and push to Docker Hub.
