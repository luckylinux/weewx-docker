#!/bin/bash

# Change to app folder
cd /opt/weewx

# Launch App
echo "Launching docker-entrypoint.sh"

# Infinite loop to debug
#if [[ -v ENABLE_DEBUG_LOOP ]]
#then
#   if [[ "${ENABLE_DEBUG_LOOP}" -eq "1" ]]
#   then
       while true
       do
          sleep 5
       done
#   fi
#fi
