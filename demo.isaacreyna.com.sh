#!/bin/bash

set -e

# Sets up demo.isaacreyna.com
function main() {
    create_pgadmin_servers
    start_app
    run_migrations
}

function create_pgadmin_servers() {
    if [[ ! -f .env ]]; then
        echo "Erro: .env file not found."
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