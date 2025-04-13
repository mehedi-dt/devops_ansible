#!/bin/bash

SITE_URL="${SITE_URL}"
APP_NAME="${APP_NAME:-$SITE_URL}"
SERVER="${SERVER:-apache2}"
BLUE_PORT="${BLUE_PORT:-3001}"
GREEN_PORT="${GREEN_PORT:-3002}"
INTERVAL="${INTERVAL:-10}"

LOG_PATH="${LOG_PATH:-/var/log/monitor_apps/$SITE_URL.log}"

echo "Monitoring $APP_NAME at $SITE_URL on $SERVER ($BLUE_PORT/$GREEN_PORT) every $INTERVAL seconds."

CONF_AVAILABLE_PATH="/etc/$SERVER/sites-available"
CONF_ENABLED_PATH="/etc/$SERVER/sites-enabled"

BLUE_PATH_CONF="$CONF_AVAILABLE_PATH/$SITE_URL.blue.conf"
GREEN_PATH_CONF="$CONF_AVAILABLE_PATH/$SITE_URL.green.conf"
SYMBOLIC_LINK="$CONF_ENABLED_PATH/$SITE_URL.conf"

APP_PATH="/var/www/$APP_NAME"
BLUE_PATH="$APP_PATH/blue"
GREEN_PATH="$APP_PATH/green"


# Function to check if a port is in use
is_port_in_use() {
    local PORT=$1
    if ss -tuln | grep ":$PORT "; then
        return 0
    else
        return 1
    fi
}

while true; do
    # Check if the application is running on port 3003 or 3004
    if is_port_in_use $BLUE_PORT || is_port_in_use $GREEN_PORT; then
        # echo $(date +"%Y-%m-%d %H:%M:%S")" - Application is running." >> $LOG_PATH
        sleep $INTERVAL
    else
        {
            echo -e "\n\nApplication is not running."
            echo $(date +"%Y-%m-%d %H:%M:%S")

            CURRENT_PATH_CONF=$(readlink -f ${SYMBOLIC_LINK})

            # Decide which directory to deploy the new release to
            if [ "${CURRENT_PATH_CONF}" = "${BLUE_PATH_CONF}" ]; then
                CURRENT_PATH=${BLUE_PATH}
                CURRENT_PORT=${BLUE_PORT}
            else
                CURRENT_PATH=${GREEN_PATH}
                CURRENT_PORT=${GREEN_PORT}
            fi

            # Change directory to deploy path
            echo "cd to ${CURRENT_PATH}."
            cd ${CURRENT_PATH} &>> ${LOG_PATH}

            # Start the node application
            echo "Starting the application in port: ${CURRENT_PORT}"
            PORT=${CURRENT_PORT} npm start 2>&1 &
            sleep 5

            if [ $? -eq 0 ]; then
                echo "Application started."
            else
                echo "Error occurred starting the application."
            fi

            sleep 15
        } &>> $LOG_PATH
    fi
done