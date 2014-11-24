#!/bin/bash

apt-get -y update

apt-get install -y curl vim

dpkg -l | grep apache2
if ! [ $? -eq 0 ]
then
    apt-get -y install apache2
    /etc/init.d/apache2 start
    echo "Done installing apache successfully ..."
fi

dpkg -l | grep elasticsearch
if ! [ $? -eq 0 ]
then
    apt-get -y install openjdk-7-jre

    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.deb
    dpkg -i elasticsearch-1.2.1.deb

    update-rc.d elasticsearch defaults 95 10
    /etc/init.d/elasticsearch start
    echo "Done installing elastic search successfully ..."
fi

test -L /opt/logstash
if ! [ $? -eq 0 ]
then
    cd /opt
    wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz
    tar xzf logstash-1.4.1.tar.gz -C /opt/
    ln -sf logstash-1.4.1 logstash
    #cd /vagrant_data/scripts
    #sh logstash.sh start
    echo "Done installing logstash successfully ..."
fi

test -d /var/www/kibana
if ! [ $? -eq 0 ]
then
    cd /tmp/
    wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz
    tar xf kibana-3.1.0.tar.gz -C /var/www/html
    cd /var/www/html
    mv kibana-3.1.0 kibana
    echo "Done installing kibana successfully ..."
fi
