POSTAL_VERSION ?= main

build: # Build single image image. Usage: make build POSTAL_VERSION="postalversion"
	@docker build --no-cache --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg POSTAL_VERSION="$(POSTAL_VERSION)" -t siebsie23/docker-postal:$(POSTAL_VERSION) .

buildx-push: # Build and push single image image. Usage: make buildx-push POSTAL_VERSION="postalversion"
	@docker buildx build --no-cache --platform linux/amd64 --push --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg POSTAL_VERSION="$(POSTAL_VERSION)" -t siebsie23/docker-postal:$(POSTAL_VERSION) .

clean: # Clean all containers and images on the system
	-@docker ps -a -q | xargs docker rm -f
	-@docker images -q | xargs docker rmi -f