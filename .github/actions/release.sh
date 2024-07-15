#!/usr/bin/env bash

set -eo pipefail

# Set the short commit hash to an empty string
SHORT_COMMIT="";

docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}";

# Check which postal version to build.
# If the postal version equals to release, get the latest release from the postal repository.
if [[ "${POSTAL_VERSION}" == "release" ]]; then
    POSTAL_VERSION=$(curl -s https://api.github.com/repos/postalserver/postal/releases/latest | jq -r .tag_name);

    # Check if the fetched postal version is already built, do not build it again.
    if [[ $(curl -s https://hub.docker.com/v2/repositories/siebsie23/docker-postal/tags/${POSTAL_VERSION} | jq -r .name) == "${POSTAL_VERSION}" ]]; then
        echo "Postal version ${POSTAL_VERSION} already exists in siebsie23/docker-postal";
        exit 0;
    fi
fi

# If the postal version is main, check if the latest commit is already built, do not build it again.
if [[ "${POSTAL_VERSION}" == "main" ]]; then
    # Get the latest commit hash from the postal repository.
    LATEST_COMMIT=$(curl -s https://api.github.com/repos/postalserver/postal/commits/main | jq -r .sha);

    # Convert the commit hash to a short commit hash.
    SHORT_COMMIT=$(echo "${LATEST_COMMIT}" | cut -c1-7);

    # Pull the image from Docker Hub
    docker pull siebsie23/docker-postal:main || true

    # Check if the image exists locally
    if docker image inspect siebsie23/docker-postal:main >/dev/null 2>&1; then
        # Get the image ID
        IMAGE_ID=$(docker images -q siebsie23/docker-postal:main)

        # Inspect the image and get the commit label
        IMAGE_COMMIT=$(docker inspect --format '{{ index .Config.Labels "commit"}}' "${IMAGE_ID}")

        # Check if the commit label is the same as the latest commit
        if [[ "${IMAGE_COMMIT}" == "${SHORT_COMMIT}" ]]; then
            echo "The latest commit ${SHORT_COMMIT} is already built in siebsie23/docker-postal:main";
            exit 0;
        fi
    else
        echo "Failed to pull siebsie23/docker-postal:main, continuing with build..."
    fi
fi

# Build the image
make buildx-push POSTAL_VERSION="${POSTAL_VERSION}" POSTAL_COMMIT=${SHORT_COMMIT};