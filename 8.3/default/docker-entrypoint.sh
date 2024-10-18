#!/bin/bash

FILE=/env/.env
if test -f "$FILE"; then
    cp /env/.env /var/www/.env
    chmod 644 /.env
fi

