#!/bin/sh
### BEGIN INIT INFO
# Provides:          elasticsearch-init
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       Starts/stops/uninstalls elasticsearch service
### END INIT INFO

SCRIPT="/elasticsearch-init.sh" --log /var/log/logstash/elasticsearch-init.log
RUNAS="root"

PIDFILE=/var/run/elasticsearch-init.pid
LOGFILE=/var/log/logstash/elasticsearch-service.log

start() {
	if [ -f /var/run/$PIDNAME ] && kill -0 $(cat /var/run/$PIDNAME); then
		echo 'Service already running' >&2
		return 1
	fi
	echo 'Starting services ... ' >&2
	local CMD="$SCRIPT &> \"$LOGFILE\" & echo \$!"
	su -c "$CMD" $RUNAS > "$PIDFILE"
	echo 'Service started !' >&2
}

stop() {
	if [ ! -f "$PIDFILE" ] || ! kill -0 $(cat "$PIDFILE"); then
		echo 'Service not running ... ' >&2
		return 1
	fi
	echo 'Stopping service ... ' >&2
	kill -15 $(cat "$PIDFILE") && rm -f "$PIDFILE"
	echo 'Service stopped !' >&2
}

uninstall() {
	echo -n "Are you really sure you want to uninstall this service? That cannot be undone. [yes|No] "
	local SURE
	read SURE
	
	if [ "$SURE" = "yes" ]; then
		stop
		rm -f "$PIDFILE"
		echo "Notice: log file is not be removed: '$LOGFILE'" >&2
		update-rc.d -f <NAME> remove
		rm -fv "$0"
	fi
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	uninstall)
		uninstall
		;;
	retart)
		stop
		start
		;;
	*)
		echo "Usage: $0 {start|stop|restart|uninstall}"
esac
