.PHONY: help start build test stop bash

DOCKER_NAME = nifi_local
ENV_FILE = $(PWD)/.env

ifneq ("$(wildcard $(ENV_FILE))", "")
	include $(ENV_FILE)
	export $(shell sed 's/=.*//' $(ENV_FILE))
endif

help: ##  shows all available targets
	@echo ""
	@echo "NiFi local server"
	@echo ""
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/\(.*\)\:.*##/\1:/'
	@echo ""

start: ## starts nifi server
	docker-compose up -d

build: ## builds/downloadds nifi docker image
	docker-compose build

test: ##  run tests
	tests/test_url.sh http://127.0.0.1:8082/nifi/

stop: ##  stops nifi server
	docker-compose stop

clear: ## stops nifi server and removes all projects
	docker-compose down

bash: ##  login to container
	docker exec -u 0 -it `docker-compose ps -q` /usr/bin/env bash
