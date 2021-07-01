#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE SCHEMA pagila;
EOSQL

sed 's/public\./pagila./g' /var/opt/pagila/pagila-schema.sql | psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" "$POSTGRES_DB"
sed 's/public\./pagila./g' /var/opt/pagila/pagila-data.sql | psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" "$POSTGRES_DB"

psql -v ON_ERROR_STOP=1  --set search_path=pagila --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    alter table pagila.actor add column attributes JSONB;
    update pagila.actor set attributes = '{"color": "red"}' where actor_id = 1;
    update pagila.actor set attributes = '{"color": "yellow"}' where actor_id = 2;

    CREATE ROLE postgraphile login PASSWORD 'password';
    ALTER ROLE postgraphile SET search_path TO pagila;

    GRANT USAGE ON SCHEMA pagila TO postgraphile;
    GRANT SELECT ON TABLE pagila.store TO postgraphile;
    GRANT SELECT ON TABLE pagila.actor TO postgraphile;
EOSQL

