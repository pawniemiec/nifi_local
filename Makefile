.PHONY: help build start logs test stop deploy bash

DOCKER_NAME=nifi_local
DOCKER_VER=0.0.1
DCR_HOST=localhost
DCR_PORT=5000
ENV_FILE=$(PWD)/.env

# Configure Nifi port if not set
ifndef NIFI_WEB_HTTP_PORT
	NIFI_WEB_HTTP_PORT=8082
endif

# Get Container ID if it's running
CONTAINER_ID := $(shell bash -c 'docker ps -a -q -f name=${DOCKER_NAME}_${DOCKER_VER}')

# Get current directory
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(dir $(MKFILE_PATH))

ifneq ("$(wildcard $(ENV_FILE))", "")
	include $(ENV_FILE)
	export $(shell sed 's/=.*//' $(ENV_FILE))
endif

help: ##   shows all available targets
	@echo ""
	@echo "${DOCKER_NAME}"
	@echo ""
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/\(.*\)\:.*##/\1:/'
	@echo ""

build: ##  builds container image
	@docker build -t ${DOCKER_NAME}:${DOCKER_VER} .

start: ##  start container
	@echo Starting container ${DOCKER_NAME}_${DOCKER_VER}
	@docker run -d -i \
		-p ${NIFI_WEB_HTTP_PORT}:8080 \
		-v ${CURRENT_DIR}/data:/data \
		-v ${CURRENT_DIR}/conf:/opt/nifi/nifi-1.6.0/conf \
		--name ${DOCKER_NAME}_${DOCKER_VER} \
		-t ${DOCKER_NAME}:${DOCKER_VER}

logs: ##   show container logs (Ctrl-C to stop)
	@docker logs ${CONTAINER_ID} -f

test: ##   run tests
	tests/test_url.sh http://127.0.0.1:${NIFI_WEB_HTTP_PORT}/nifi/

stop: ##   stops and removes container
	@echo Stopping container ${CONTAINER_ID}
	@docker stop -t 0 ${CONTAINER_ID}
	@echo Removing container ${DOCKER_NAME}_${DOCKER_VER}
	@docker rm ${CONTAINER_ID}

deploy: ## deploys image to container registry
	@echo Tagging container ${DOCKER_NAME}:${DOCKER_VER}
	@docker tag ${DOCKER_NAME}:${DOCKER_VER} ${DCR_HOST}:${DCR_PORT}/${DOCKER_NAME}
	@echo Deploying container ${DOCKER_NAME}:${DOCKER_VER}
	@docker push ${DCR_HOST}:${DCR_PORT}/${DOCKER_NAME}

bash: ##   login to container
	@echo "Login into container ${DOCKER_NAME}:${DOCKER_VER} -> ${CONTAINER_ID}"
	@docker exec -u 0 -it ${CONTAINER_ID} bash
