#!/bin/bash

crond -l 2

CRONJOB_FILE=/config/cronjob.sh
if [ ! -f "$CRONJOB_FILE" ]; then
	echo "$CRONJOB_FILE does not exist"
	cp /cronjob.sh "$CRONJOB_FILE"
fi
chmod 777 "$CRONJOB_FILE"

CRON_FILE=/config/cron.txt
if [ ! -f "$CRON_FILE" ]; then
	cp /sample_cron.txt "$CRON_FILE"
fi
. "$CRON_FILE"

XTEVE_FILE=/config/xteve.txt
if [ ! -f "$XTEVE_FILE" ]; then
	cp /sample_xteve.txt "$XTEVE_FILE"
fi
. "$XTEVE_FILE"

exit
