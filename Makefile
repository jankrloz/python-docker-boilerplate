SHELL=/bin/bash

ifndef VERBOSE
.SILENT:
endif

export COMPOSE_PROJECT_NAME=table-to-core-model

DOCKER-COMPOSE=docker-compose \
		-f ./infrastructure/docker-compose.yml \
		-f ./infrastructure/docker-compose.local.yml

venv:
	@if [ ! -d venv ]; then python3 -m venv --copies venv; fi;


install: venv
	@echo "Installing dependencies locally"
	@( \
		source venv/bin/activate; \
		pip install -qU pip; \
		pip install -r requirements.txt; \
	)

build-force: PARAMS = --no-cache
build build-force:
	$(DOCKER-COMPOSE) build --parallel --force-rm --pull $(PARAMS)

start: install
	echo "*** Starting up services ***"
	$(DOCKER-COMPOSE) up -d

restart: stop start

fresh-start: clean build start
	echo "*** Fresh starting up services ***"

stop:
	echo "*** Stopping services ***"
	$(DOCKER-COMPOSE) down

clean:
	echo "*** Cleaning up services ***"
	$(DOCKER-COMPOSE) rm -fsv

boom:
	echo "*** BOOM! ***"
	$(DOCKER-COMPOSE) down -v --rmi all

bash:
	$(DOCKER-COMPOSE) run main /bin/sh

status:
	echo "*** Status of containers ***"
	$(DOCKER-COMPOSE) ps


debug: PARAMS = -f
logs debug: start
	echo "*** Showing containers logs ***"
	$(DOCKER-COMPOSE) logs -t $(PARAMS)
