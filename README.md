# NiFi local server
Latest version of Apache Nifi 

## Prerequisites
This project is dependent on the following libs and programs:
- docker
- make
- curl

## License
All code is licensed under MIT license.

## Makefile
- help:  shows all available targets
- start: starts NiFi server
- build: builds/downloadds NiFi docker image
- test:  run tests
- stop:  stops NiFi and clears data
- bash:  login to container

## Usage
Docker mounts ./data directory as /data inside container, hnce if yo want to resist anything, please save it to `/data/` directory

There is no automatic "load" of configuration. Please refer to Apache NiFi documentation and update Docker Compose accordingly:
https://nifi.apache.org/docs.html

Nifi will run on port 8082 by default (which is a mapping form container internal 8080).

If you want to configure custom port set:
```bash
export NIFI_WEB_HTTP_PORT=<port of your choice>
```
