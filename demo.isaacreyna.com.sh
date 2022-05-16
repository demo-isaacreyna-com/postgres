#!/bin/bash

set -e

# Sets up demo.isaacreyna.com
function main() {
    create_pgadmin_servers
    start_app
}

function create_pgadmin_servers() {
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
    docker-comopse --profile all up -d
}

main "$@"