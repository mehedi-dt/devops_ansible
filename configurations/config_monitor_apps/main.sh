#!/bin/bash
# that's the entrypoint for the monitor script

# callig the script for app 1
SITE_URL="dev.exmaple.com" \
BLUE_PORT=3001 \
GREEN_PORT=3002 \
INTERVAL=10 \
/scripts/monitor_apps/monitor.sh &

# callig the script for app 2
SITE_URL="uat.exmaple.com" \
BLUE_PORT=4001 \
GREEN_PORT=4002 \
INTERVAL=10 \
/scripts/monitor_apps/monitor.sh &

wait