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

mup:
	docker compose -f ${DOCKER_COMPOSE_FILE} --profile tools run --rm migrate up

mdown:
	docker compose -f ${DOCKER_COMPOSE_FILE} --profile tools run --rm migrate down

arg-check:
ifndef name
	@echo "エラー: 'name'が設定されていません。使用法: make create-create-sql name=テーブル名"
	exit 1
endif

create-create-sql: arg-check
	docker compose -f ${DOCKER_COMPOSE_FILE} --profile tools run --rm migrate create -ext sql -dir /migrations create_tabel_$(name)

create-init-sql: arg-check
	docker compose -f ${DOCKER_COMPOSE_FILE} --profile tools run --rm migrate create -ext sql -dir /migrations init_data_$(name)
	rm ./postgres/migrations/*_init_data_$(name).down.sql
	touch ./postgres/seed/$(name).csv
	echo "COPY $(name) FROM '/seed/$(name).csv' DELIMITER ',' CSV HEADER;を作製されたinitファイルに書き込んでください"

create-alter-sql: arg-check
	docker compose -f ${DOCKER_COMPOSE_FILE} --profile tools run --rm migrate create -ext sql -dir /migrations alter_table_$(name)

create-trigger-sql: arg-check
	docker compose -f ${DOCKER_COMPOSE_FILE} --profile tools run --rm migrate create -ext sql -dir /migrations trigger_table_$(name)

shell-db:
	docker compose -f ${DOCKER_COMPOSE_FILE} exec postgres psql -U ${POSTGRES_USER} -d ${POSTGRES_PASSWORD}
