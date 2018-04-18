# Nifi local server

## Prerequisites
This project is dependent on the following libs and programs:
- docker
- docker-compose
- make
- curl

## License
All code is licensed under MIT license.

## Makefile
- help:  shows all available targets
- start: starts nifi server
- build: builds/downloadds nifi docker image
- test:  run tests
- stop:  stops mysql and clears data
- bash:  login to container
