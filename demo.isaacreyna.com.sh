#!/bin/bash

set -e

# Sets up demo.isaacreyna.com
function main() {
    create_env_file
    validate_env_file
    create_pgadmin_servers
    start_app
    run_migrations
}

function validate_env_file() {
    if [[ ! -f .env ]]; then
        echo "Error: .env does not exist!"
        exit 1
    else
        source .env

        if [[ -z "${COMPOSE_PROJECT_NAME}" ]]; then
            echo "Error: COMPOSE_PROJECT_NAME is not set"
            exit 1
        fi

        if [[ -z "${POSTGRES_HOST}" ]]; then
            echo "Error: POSTGRES_HOST is not set"
            exit 1
        fi

        if [[ -z "${POSTGRES_USER}" ]]; then
            echo "Error: POSTGRES_USER is not set"
            exit 1
        fi

        if [[ -z "${POSTGRES_PASSWORD}" ]]; then
            echo "Error: POSTGRES_PASSWORD is not set"
            exit 1
        fi

        if [[ -z "${POSTGRES_DB}" ]]; then
            echo "Error: POSTGRES_DB is not set"
            exit 1
        fi

        if [[ -z "${PGADMIN_DEFAULT_EMAIL}" ]]; then
            echo "Error: PGADMIN_DEFAULT_EMAIL is not set"
            exit 1
        fi

        if [[ -z "${PGADMIN_DEFAULT_PASSWORD}" ]]; then
            echo "Error: PGADMIN_DEFAULT_PASSWORD is not set"
            exit 1
        fi

        if [[ -z "${PORT}" ]]; then
            echo "Error: PORT is not set"
            exit 1
        fi
    fi
}

function create_env_file() {
    if [[ ! -f .env ]]; then
        cat << EOF > .env
COMPOSE_PROJECT_NAME=
POSTGRES_HOST=
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_DB=
PGADMIN_DEFAULT_EMAIL=
PGADMIN_DEFAULT_PASSWORD=
PORT=
EOF
        echo "NOTICE: .env created. Edit .env and set values"
        exit 1
    fi
}

function create_pgadmin_servers() {
    if [[ ! -f .env ]]; then
        echo "Error: .env file not found."
        exit 1
    fi

    source .env
    cat << EOF > servers.json
{
    "Servers": {
        "1": {
            "Name": "${COMPOSE_PROJECT_NAME}",
            "Group": "Servers",
            "Host": "${POSTGRES_HOST}",
            "Port": ${PORT},
            "MaintenanceDB": "${POSTGRES_DB}",
            "Username": "${POSTGRES_USER}",
            "SSLMode": "prefer"
        }
    }
}
EOF
}

function start_app() {
    docker-compose down
    docker-compose --profile all up -d
}

function run_migrations() {
     docker exec -d django python manage.py migrate 
}

main "$@"