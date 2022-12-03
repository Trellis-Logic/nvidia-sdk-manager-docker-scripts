# nvidia-sdk-manager-docker-scripts

This repository attempts to automate some of the steps in the [docker image](https://docs.nvidia.com/sdk-manager/docker-containers/index.html)
instructions of the [Nvidia SDK Manager](https://developer.nvidia.com/drive/sdk-manager)
docker image deployment instructions.

This is (hopefully) useful for people who want to be able to download and/or deploy
NVIDIA Jetpack content on development hardware and need to periodically use older SDK
releases which aren't supported on certain Ubuntu OS base images.

# Setup

Install docker for your host, and configure your account to run docker without using sudo
by adding to the `docker` group.

# Usage

1. Edit the `docker-run-sdk-manager.sh` script and change target and version variables.
2. Put your device in recovery mode and connect to your host
3. Run `./docker-run-sdk-manager.sh` to kick off the process
  * The first time you run, the script prompts you to download the associated image from
NVIDIA's developer site and place in a temp directory.
