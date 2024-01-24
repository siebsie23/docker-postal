#!/usr/bin/env bash

set -eo pipefail

if [[ "${GITHUB_REF}" == refs/heads/main || "${GITHUB_REF}" == refs/tags/* ]]; then
    docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}";
    make buildx-push POSTAL_VERSION="${POSTAL_VERSION}";
fi