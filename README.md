# postgres

## demo.isaacreyna.com.sh
Creates an .env file with unset variables used to connect to the database and docker-compose. If variables are set, then this script will run docker-compose to bring up the app.

## initialize-database.sh
This script is used as an entrypoint script for postgres.

## servers.json
This file created by the script, `demo.isaacreyna.com.sh`, and used by pgadmin to populate servers for you.
```json
{
    "Servers": {
        "1": {
            "Name": "Display name",
            "Group": "Group for this server",
            "Host": "Hostname of the server",
            "Port": 5432,
            "MaintenanceDB": "Target database",
            "Username": "Database user",
            "SSLMode": "prefer"
        }
    }
}
```

## Jenkinsfile
Deploys a postgres container