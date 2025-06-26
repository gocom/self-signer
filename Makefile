.PHONY: all build help push run

DOCKER_IMAGE_NAME ?= ghcr.io/gocom/self-signer
DOCKER_IMAGE_TAG ?= dev
DOCKER_IMAGE_PLATFORM ?= linux/amd64
DOCKER_IMAGE_COMMAND ?= bash

all: help

build:
	docker build --platform $(DOCKER_IMAGE_PLATFORM) -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

push:
	docker build --platform $(DOCKER_IMAGE_PLATFORM) -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) . --push

run:
	docker run -it --rm "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" "$(DOCKER_IMAGE_COMMAND)"

help:
	@echo "Manage project"
	@echo ""
	@echo "Usage:"
	@echo "  $$ make [command] ["
	@echo "    [DOCKER_IMAGE_NAME=<image>]"
	@echo "    [DOCKER_IMAGE_TAG=<tag>]"
	@echo "    [DOCKER_IMAGE_PLATFORM=<platform>]"
	@echo "    [DOCKER_IMAGE_COMMAND=<command>]"
	@echo "  ]"
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  $$ make build"
	@echo "  Build Docker image"
	@echo ""
	@echo "  $$ make help"
	@echo "  Print this message"
	@echo ""
	@echo "  $$ make push"
	@echo "  Build and push Docker image"
	@echo ""
	@echo "  $$ make run"
	@echo "  Run the built Docker image"
	@echo ""
