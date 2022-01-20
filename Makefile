# Default Shell
SHELL=/bin/bash


# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


# Default GOAL
.DEFAULT_GOAL := help


# Image configuration
ALPINE_VERSION ?= $(shell docker run --rm -t alpine:latest head -1 /etc/alpine-release|tr -d '\r'|grep -o -E "[0-9]{1,2}\.[0-9][0-9]")
IMAGE_NAME ?= $(or ${DOCKER_IMAGE},${DOCKER_IMAGE},postgres:master)
DATA_DIR ?= $(or ${DATA_DIR},${DATA_DIR},data)
PUID ?= 1034
PGID ?= 100


# DOCKER TASKS
# Build the container
build: ## Build the container
	@echo "Building PostgreSQL with alpine: $(ALPINE_VERSION)"
	@docker build --build-arg=ALPINE_VERSION=$(ALPINE_VERSION) -t $(IMAGE_NAME) .


# Run the container
run: ## Run the container
	@mkdir -p ${PWD}/data
	@docker run \
		--rm \
		--name psql-master \
		--hostname psql \
		-e TZ=Europe/Amsterdam \
		-e PUID=$(PUID) \
		-e PGID=$(PGID) \
		-e DB_USER=test \
		-e DB_PASS=test \
		-e DB_NAME=test \
		-v $(DATA_DIR):/config \
		--interactive \
		--tty \
		$(IMAGE_NAME)


# Create shell in container
shell: ## Container Shell
	@docker exec -it psql-master bash


# Clean data directory
clean: ## Clean
	@rm -rf ${PWD}/data
