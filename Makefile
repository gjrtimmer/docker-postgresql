# Default Shell
SHELL			= /bin/bash
PROJECTDIR		= $(CURDIR)
COMMIT			= $(shell git rev-parse --short HEAD)
THIS 			:= $(lastword $(MAKEFILE_LIST))
MAKEFLAGS 		+= --no-print-directory


################################################################################
# Include Makefiles
include $(PROJECTDIR)/Makefile.help


################################################################################
# Build variables
PSQL_VERSION	:= $(or ${PSQL_VERSION},latest)
ALPINE_VERSION 	:= $(or ${ALPINE_VERSION},latest)
DOCKER_FILE 	:= $(or ${DOCKER_FILE},Dockerfile)
IMAGE_NAME 		:= $(or ${DOCKER_IMAGE},postgres:$(PSQL_VERSION))

ifeq ($(ALPINE_VERSION),latest)
	ALPINE_VERSION := $(shell docker run --rm -t alpine:$(ALPINE_VERSION) head -1 /etc/alpine-release|tr -d '\r'|grep -o -E "[0-9]{1,2}\.[0-9][0-9]")
endif


################################################################################
# Run variables
PUID 			:= $(or ${PUID},1000)
PGID 			:= $(or ${PGID},100)
DATA_DIR 		:= $(or ${DATA_DIR},$(CURDIR)/data)


################################################################################
build-vars: ## Show build variables
	@echo "Dockerfile:     $(DOCKER_FILE)"
	@echo "Image Tag:      $(IMAGE_NAME)"
	@echo "Alpine Image:   $(ALPINE_VERSION)"


################################################################################
# DOCKER TASKS
# Build the container
build: build-vars ## Build the container
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


################################################################################
build-9: ## Build PostgreSQL:9
	@$(MAKE) -f $(THIS) build PSQL_VERSION=9 ALPINE_VERSION=3.15 DOCKER_FILE=Dockerfile.9


################################################################################
build-10: ## Build PostgreSQL:10
	@$(MAKE) -f $(THIS) build PSQL_VERSION=10 ALPINE_VERSION=3.15 DOCKER_FILE=Dockerfile.10


################################################################################
build-11: ## Build PostgreSQL:11
	@$(MAKE) -f $(THIS) build PSQL_VERSION=11 ALPINE_VERSION=3.15 DOCKER_FILE=Dockerfile.11


################################################################################
build-12: ## Build PostgreSQL:12
	@$(MAKE) -f $(THIS) build PSQL_VERSION=12 ALPINE_VERSION=3.15 DOCKER_FILE=Dockerfile.12


################################################################################
build-13: ## Build PostgreSQL:13
	@$(MAKE) -f $(THIS) build PSQL_VERSION=13 ALPINE_VERSION=3.15 DOCKER_FILE=Dockerfile.13


################################################################################
build-14: ## Build PostgreSQL:14
	@$(MAKE) -f $(THIS) build PSQL_VERSION=14 ALPINE_VERSION=3.15 DOCKER_FILE=Dockerfile.14


################################################################################
all: build-9 build-10 build-11 build-12 build-13 build-14 build


################################################################################
# Push Container to registry
push:
	@docker push $(IMAGE_NAME)


################################################################################
# Inspect build image
build-inspect: ## Inspect build
	@docker inspect $(IMAGE_NAME)


################################################################################
run-vars: ## Show run variables
	@echo "Image Tag:      $(IMAGE_NAME)"
	@echo "Data Directory: $(DATA_DIR)"
	@echo "UID:            $(PUID)"
	@echo "GID:            $(PGID)"


################################################################################
# Run the container
run: run-vars ## Run the container
	@mkdir -p ${PWD}/data
	@docker run \
		--rm \
		--name psql-test-$(PSQL_VERSION) \
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


################################################################################
run-9: build-9 ## Run PostgreSQL:9
	@$(MAKE) -f $(THIS) run PSQL_VERSION=9


################################################################################
run-10: build-10 ## Run PostgreSQL:10
	@$(MAKE) -f $(THIS) run PSQL_VERSION=10


################################################################################
run-11: build-11 ## Run PostgreSQL:11
	@$(MAKE) -f $(THIS) run PSQL_VERSION=11


################################################################################
run-12: build-12 ## Run PostgreSQL:12
	@$(MAKE) -f $(THIS) run PSQL_VERSION=12


################################################################################
run-13: build-13 ## Run PostgreSQL:13
	@$(MAKE) -f $(THIS) run PSQL_VERSION=13


################################################################################
run-14: build-14 ## Run PostgreSQL:14
	@$(MAKE) -f $(THIS) run PSQL_VERSION=14


################################################################################
# Create shell in container
shell: ## Container Shell PostgreSQL:latest
	@docker exec -it psql-test bash


################################################################################
# Create shell in container
shell-9: ## Container Shell PostgreSQL:9
	@docker exec -it psql-test-9 bash


################################################################################
# Create shell in container
shell-10: ## Container Shell PostgreSQL:10
	@docker exec -it psql-test-10 bash


################################################################################
# Create shell in container
shell-11: ## Container Shell PostgreSQL:11
	@docker exec -it psql-test-11 bash


################################################################################
# Create shell in container
shell-12: ## Container Shell PostgreSQL:12
	@docker exec -it psql-test-12 bash


################################################################################
# Create shell in container
shell-13: ## Container Shell PostgreSQL:13
	@docker exec -it psql-test-13 bash


################################################################################
# Create shell in container
shell-14: ## Container Shell PostgreSQL:14
	@docker exec -it psql-test-14 bash


################################################################################
# Clean data directory
clean: ## Clean
	@sudo rm -rf $(CURDIR)/data/*

clean-9: ## Clean PostgreSQL:9
	@sudo rm -rf $(CURDIR)/data/9.*

clean-10: ## Clean PostgreSQL:10
	@sudo rm -rf $(CURDIR)/data/10.*

clean-11: ## Clean PostgreSQL:11
	@sudo rm -rf $(CURDIR)/data/11.*

clean-12: ## Clean PostgreSQL:12
	@sudo rm -rf $(CURDIR)/data/12.*

clean-13: ## Clean PostgreSQL:13
	@sudo rm -rf $(CURDIR)/data/13.*

clean-14: ## Clean PostgreSQL:14
	@sudo rm -rf $(CURDIR)/data/14.*
