POSTGRES_PASSWORD:=password
POSTGRES_USER:=postgres
# Use postgraphile user for restricted types
# POSTGRES_USER:=postgraphile

build:
	docker build . -t graphtastic

up: submodule
	POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) \
	POSTGRES_USER=$(POSTGRES_USER) \
	docker-compose up

submodule:
	git submodule update --init
