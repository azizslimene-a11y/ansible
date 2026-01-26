#!bin/sh
USER_NAME="$(logname 2>/dev/null || whoami)"
echo "$USER_NAME"
