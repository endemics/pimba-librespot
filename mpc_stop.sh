#!/bin/sh
if [ "$PLAYER_EVENT" = "start" -o "$PLAYER_EVENT" = "stop" ]
then
    /usr/bin/mpc -h mopidy -q stop
fi
