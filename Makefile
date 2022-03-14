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
DOCKER_FILE := $(or ${DOCKER_FILE},Dockerfile)
IMAGE_NAME := $(or ${DOCKER_IMAGE},postgres:latest)
DATA_DIR := $(or ${DATA_DIR},data)
ALPINE_VERSION := $(or ${ALPINE_VERSION},${ALPINE_VERSION},latest)


# DOCKER TASKS
# Build the container
# $(eval PSQL_VERSION ?= $(shell docker run --rm --name postgres.version --entrypoint='' -t postgres.version postgres --version))
# $(eval PGV ?= $(shell echo "$(PSQL_VERSION)" | awk '{print $$3}'))
# $(eval PGV_SHORT ?= $(shell echo $(PGV) | grep -o -E "[0-9]{1,2}\.[0-9]"))
build: ## Build the container
	$(eval ALPINE_VERSION ?= $(shell docker run --rm -t alpine:$(ALPINE_VERSION) head -1 /etc/alpine-release|tr -d '\r'|grep -o -E "[0-9]{1,2}\.[0-9][0-9]"))
	$(eval BUILD_DATE ?= $(shell date -u +"%Y-%m-%dT%H:%M:%SZ"))
	$(eval CI_PROJECT_URL ?= $(or ${CI_PROJECT_URL},${CI_PROJECT_URL},$(shell echo $$(git config --get remote.origin.url | sed 's/....$$//'))))
	$(eval CI_COMMIT_SHORT_SHA ?= $(or ${CI_COMMIT_SHORT_SHA},${CI_COMMIT_SHORT_SHA},$(shell git rev-parse --short HEAD)))
	@echo "Building PostgreSQL on Alpine: $(ALPINE_VERSION)"
	@docker build \
		--pull \
		--build-arg DOCKER_IMAGE="$(IMAGE_NAME)" \
		--build-arg=ALPINE_VERSION="$(ALPINE_VERSION)" \
		--build-arg BUILD_DATE="$(BUILD_DATE)" \
		--build-arg VCS_REF="$(CI_COMMIT_SHORT_SHA)" \
		--build-arg CI_PROJECT_URL="$(CI_PROJECT_URL)" \
		--build-arg CI_PROJECT_NAME="postgresql" \
		--file=$(DOCKER_FILE) \
		--tag $(IMAGE_NAME) .


# Push Container to registry
push:
	@docker push $(IMAGE_NAME)

# Inspect build image
build-inspect: ## Inspect build
	@docker inspect $(IMAGE_NAME)


# Run the container
run: ## Run the container
	$(eval PUID ?= 1034)
	$(eval PGID ?= 100)
	@mkdir -p ${PWD}/data
	@docker run \
		--rm \
		--name psql-test \
		--hostname psql \
		-e TZ=Europe/Amsterdam \
		-e PUID=$(PUID) \
		-e PGID=$(PGID) \
		-e DB_USER=test \
		-e DB_PASS=test \
		-e DB_NAME=test \
		-e PL_PERL=true \
		-e PL_PYTHON=true \
		-e PL_TCL=true \
		-v $(DATA_DIR):/config \
		--interactive \
		--tty \
		$(IMAGE_NAME)


# Create shell in container
shell: ## Container Shell
	@docker exec -it psql-test bash


# Clean data directory
clean: ## Clean
	@rm -rf ${PWD}/data
