#!/bin/sh
USER_NAME="$(logname 2>/dev/null || whoami)"
echo "$USER_NAME"
case "$1" in
   start)
     echo -n "
            REAl TIME COLLECTOR START "

     cd /home/$USER_NAME/collectors/rt_1
     java -jar rt*.jar 01 1>> /srv/www/tracking/log_succcess_rt_1.log 2>> /srv/www/tracking/log_err_rt_1.log &

   ;;
   stop)
    echo "Stopping collectors for user $RUN_USER"

    pids=$(pgrep -f "\.jar")

    if [ -z "$pids" ]; then
        echo "  No collectors running"
        return
    fi

    echo "$pids" | xargs kill
    sleep 2
   ;;


restart)
      sh $0  stop
      sh $0  start
 ;;


    status)
var=$(pgrep -f "\.jar")
if [ $var -eq 0 ]
then
echo "real_time_collector.pid  is NOTrunning"
else
echo "real_time_collector.pid  is  running"
exit 1
fi

       ;;


esac
