#!/bin/sh
### BEGIN INIT INFO
# Provides:          real_time_collector
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Real Time Collector service
# Description:       Start/Stop all collector JARs dynamically
### END INIT INFO

# Detect real user & HOME (works across machines)
RUN_USER=$(logname 2>/dev/null || echo "$SUDO_USER" || echo "$USER")
HOME_DIR=$(eval echo "~$RUN_USER")

BASE_DIR="$HOME_DIR/collectors"
JAVA_OPTS="-XX:+UseSerialGC"

start() {
    echo "Starting collectors for user $RUN_USER"

    find "$BASE_DIR" -type f -name "*.jar" | while read -r jar; do
        dir=$(dirname "$jar")
        name=$(basename "$jar")

        echo "  -> Starting $name in $dir"
        (
            cd "$dir" || exit 1
            nohup java $JAVA_OPTS -jar "$name" > collector.log 2>&1 &
        )
    done
}

stop() {
    echo "Stopping collectors for user $RUN_USER"

    pids=$(pgrep -u "$RUN_USER" -f "java.*\.jar")

    if [ -z "$pids" ]; then
        echo "  No collectors running"
        return
    fi

    echo "$pids" | xargs kill
    sleep 2

    # Force kill if needed
    pgrep -u "$RUN_USER" -f "java.*\.jar" >/dev/null && \
        pgrep -u "$RUN_USER" -f "java.*\.jar" | xargs kill -9
}

status() {
    if pgrep -u "$RUN_USER" -f "java.*\.jar" >/dev/null; then
        echo "Collectors are RUNNING"
        pgrep -u "$RUN_USER" -af "java.*\.jar"
    else
        echo "Collectors are NOT running"
    fi
}

restart() {
    stop
    sleep 1
    start
}

case "$1" in
    start)   start ;;
    stop)    stop ;;
    restart) restart ;;
    status)  status ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac

exit 0
