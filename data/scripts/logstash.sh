#!/bin/bash

LOGSTASH_HOME=/opt/logstash

__start() {
    cd ${LOGSTASH_HOME}
    bin/logstash -f /vagrant_data/conf/logstash/logstash.conf 1>/var/log/logstash.log 2>/var/log/logstash_err.log &
    echo $$ > /var/log/logstash.pid
    disown
}

__stop() {
    kill `cat /var/log/logstash.pid`
}

case "$1" in
    "start")
        __start
        ;;
    "stop")
        __stop
        ;;
    "restart")
        __stop
        sleep 1
        __start
        ;;
    *)
        echo "Utilisez start/stop/restart"
        ;;
esac
