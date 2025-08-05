#!/bin/bash
set -e

# Supported distros and their Dockerfiles
declare -A DISTROS=(
    [ubuntu]="Dockerfile.ubuntu"
    [manjaro]="Dockerfile.manjaro"
    [mint]="Dockerfile.linuxmint"
    [fedora]="Dockerfile.fedora"
    [centos]="Dockerfile.centos"
)

# Colors
bold="\033[1m"
green="\033[32m"
red="\033[31m"
reset="\033[0m"

# Input validation
if [[ -z "$1" ]]; then
    echo -e "${red}Usage:${reset} ./docker.sh <distro>"
    echo -e "${bold}Supported distros:${reset} ${!DISTROS[@]}"
    exit 1
fi

DISTRO="$1"
DOCKERFILE="${DISTROS[$DISTRO]}"

if [[ -z "$DOCKERFILE" ]]; then
    echo -e "${red}Error:${reset} Unsupported distro '${DISTRO}'"
    echo -e "${bold}Supported distros:${reset} ${!DISTROS[@]}"
    exit 1
fi

# Image tag
IMAGE_TAG="dotfiles-${DISTRO}"

echo -e "${green}${bold}→ Building image for ${DISTRO}...${reset}"
docker build -t "$IMAGE_TAG" -f "$DOCKERFILE" .

echo -e "${green}${bold}→ Running container...${reset}"
docker run -it --rm \
  -v "$(pwd)/..:/dotfiles" \
  --name "${DISTRO}-container" \
  "$IMAGE_TAG"
