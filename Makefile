#===================#
#== Env Variables ==#
#===================#
DOCKER_COMPOSE_FILE ?= docker-compose.yml
POSTGRES_USER ?= postgres
POSTGRES_PASSWORD ?= secret

#========================#
#== DATABASE MIGRATION ==#
#========================#

.DEFAULT_GOAL := up
up:
	docker-compose up

mup: ## Run migrations UP
mup:
	docker compose -f ${DOCKER_COMPOSE_FILE} --profile tools run --rm migrate up

mdown: ## Rollback migrations against non test DB
mdown:
	docker compose -f ${DOCKER_COMPOSE_FILE} --profile tools run --rm migrate down

mcreate: ## Create a DB migration files e.g `make mcreate name=migration-name`
mcreate:
	docker compose -f ${DOCKER_COMPOSE_FILE} --profile tools run --rm migrate create -ext sql -dir /migrations $(name)

## name_pattern
## create table : create_tabel_<table_name>
## create sequence : create_sequence_<table_name>
## insert init data : init_data_<table_name>

shell-db: ## Enter to database console
shell-db:
	docker compose -f ${DOCKER_COMPOSE_FILE} exec postgres psql -U ${POSTGRES_USER} -d ${POSTGRES_PASSWORD}
