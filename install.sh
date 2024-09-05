#!/bin/bash

set -e

## Build ARGs
NCPUS=${NCPUS:--1}
QUARTO_VERSION="1.5.57"

## Function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt_install \
    curl \
    g++ \
    gcc \
    gdebi \
    libfmt-dev \
    clang

## Install quarto cli
curl -o quarto-linux-${TARGETARCH}.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${TARGETARCH}.deb
gdebi --non-interactive quarto-linux-${TARGETARCH}.deb
rm -rf quarto-linux-${TARGETARCH}.deb

## Install Quarto Jupyter extension
python3 -m pip install jupyterlab-quarto

# Install vs code
apt_install libx11-xcb1 gnupg dirmngr
wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O code_stable_amd64.deb
apt-get -y install ./code_stable_amd64.deb
rm -rf ./code_stable_amd64.deb

## Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages