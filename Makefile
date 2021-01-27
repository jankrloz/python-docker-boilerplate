SHELL=/bin/bash

ifndef VERBOSE
.SILENT:
endif

DOCKER-COMPOSE=docker-compose \
		-f ./infrastructure/docker-compose.yml \
		-f  ./infrastructure/docker-compose.local.yml

venv:
	@if [ ! -d venv ]; then python3 -m venv --copies venv; fi;


install: venv
	@echo "Installing dependencies locally"
	@( \
		source venv/bin/activate; \
		pip install -qU pip; \
		pip install -r requirements.txt; \
	)


start: PARAMS = -d
build-start: PARAMS = --build -d
start build-start: install
	echo "*** Starting up services ..."
	$(DOCKER-COMPOSE) up $(PARAMS)

restart: stop start

fresh-start: clean build-start
	echo "*** Fresh starting up services ..."

stop:
	echo "*** Stopping up services ..."
	$(DOCKER-COMPOSE) down

clean:
	echo "*** Cleaning up services..."
	$(DOCKER-COMPOSE) rm -fsv

full-clean:
	echo "*** Full Cleaning services ..."
	$(DOCKER-COMPOSE) down -v --rmi all


bash: start
	$(DOCKER-COMPOSE) exec main /bin/sh

status:
	echo "*** Status of containers ..."
	$(DOCKER-COMPOSE) ps


debug: PARAMS = -f
logs debug: start
	echo "*** Showing containers logs ..."
	$(DOCKER-COMPOSE) logs -t $(PARAMS)
