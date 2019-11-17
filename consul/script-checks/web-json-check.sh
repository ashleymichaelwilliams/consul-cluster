#!/bin/bash

# Input Variables
WEB_URL=$1
FILTER=$2
VALUE=$3


# Test
WEB_CHECK=$(curl -sL "$WEB_URL" | jq -r "$FILTER" | grep "$VALUE")


# Logic
if [ "$WEB_CHECK" != "$VALUE" ]
then
  echo "Failed"
  exit 1

elif [ "$WEB_CHECK" == "$VALUE" ]
then
  echo "Passed"
  exit 0

fi
