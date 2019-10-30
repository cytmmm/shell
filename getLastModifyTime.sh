#!/bin/bash
#
#
#

FILE_NAME=$1

LAST_MODIFY_TIMESTAMP=$(stat -c %Y  "$FILE_NAME")
formart_date=$(date '+%Y-%m-%d %H:%M:%S' -d @"$LAST_MODIFY_TIMESTAMP")
echo "$formart_date"
exit 0
