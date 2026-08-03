SHELL := /usr/bin/env bash

DOCKER ?= docker

all:
	$(DOCKER) build -t eca/eca-sandbox-image .
