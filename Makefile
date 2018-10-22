# Project variable names, if export PROJECT_NAME=<some_value> will overwrite the settings
PROJECT_NAME ?= todobackend
ORG_NAME ?= jeremyxu666
REPO_NAME ?= todobackend

# Filenames
DEV_COMPOSE_FILE := docker/dev/docker-compose.yml
REL_COMPOSE_FILE := docker/release/docker-compose.yml

# Docker Compose Project Name, if the build_id is not set, it will just evaluate as an empty value
REL_PROJECT := $(PROJECT_NAME)$(BUILD_ID)
DEV_PROJECT := $(PROJECT_NAME)dev

.PHONY: test build release clean

test:
	${INFO} "Creating testing environment..."
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) build
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up agent
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up app
	${INFO} "Test stage has finished."

build:
	${INFO} "Building wheelhouse package from test enviornment..."
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up builder
	rm -f target/*
	docker cp $(DEV_PROJECT)_builder_1:/build/. target/
	${INFO} "Built package has been saved in the target/ folder"

release:
	${INFO} "Creating release environment..."
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) build
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) up agent
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) run --rm app manage.py collectstatic --noinput
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) run --rm app manage.py migrate --noinput
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) up nginx
	${INFO} "Nginx and Django web server is up and running on 'http//:localhost:8000' ..."

clean:
	${INFO} "Destroying development environment..."
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) kill
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) rm -f
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) kill
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) rm -f
	${INFO} "Clean Completed!"

# Cosmetics
YELLOW := "\e[1;33m"
# No Color
NC := "\e[0m"

# Shell Function to print segmentation message
# @bash -c '\
# printf $(YELLOW) \
# echo "Clean Completed!"; \
# printf $(NC);'


INFO := @bash -c '\
  printf $(YELLOW); \
  echo "$$1"; \
  printf $(NC);' VALUE