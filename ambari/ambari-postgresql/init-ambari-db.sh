#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE USER ambari WITH PASSWORD 'ambari';
  CREATE DATABASE ambari;
  GRANT ALL PRIVILEGES ON DATABASE ambari TO ambari;

  \c ambari

  \i /ambari/Ambari-DDL-Postgres-CREATE.sql

  \pset tuples_only
  \o /tmp/grant-privs
SELECT 'GRANT SELECT,INSERT,UPDATE,DELETE ON "' || schemaname || '"."' || tablename || '" TO ambari ;'
FROM pg_tables
WHERE tableowner = CURRENT_USER and schemaname = 'public';
  \o
  \i /tmp/grant-privs
EOSQL
