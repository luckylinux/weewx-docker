#!/bin/bash

# Change to app folder
cd /opt/weewx

# Execute Docker-Entrypoint
echo "Launching docker-entrypoint.sh"

# set timezone using environment
ln -snf /usr/share/zoneinfo/"${TIMEZONE:-UTC}" /etc/localtime

# start the syslog daemon as root
/sbin/syslogd -n -S -O - &

# Launch App
echo "Starting weewxd"
weewxd --config=/etc/weewx/weewx.conf "$@"

# Infinite loop
echo "ENABLE_INFINITE_LOOP = ${ENABLE_INFINITE_LOOP}"

if [[ -v ENABLE_INFINITE_LOOP ]]
then
   if [[ "${ENABLE_INFINITE_LOOP}" == "yes" ]]
   then
       echo "Starting Infinite Loop"
       while true
       do
          sleep 5
       done
   fi
fi
