#/bin/bash

apt-get -y update

apt-get install -y curl vim 

echo "Installing java ... "
apt-get -y install openjdk-7-jre

dpkg -l | grep logstash
if ! [ $? -eq 0 ]
then 
	echo "Installing logstash ..."
	apt-get -y update
	mkdir /opt/logstash
	cd /opt/logstash
	wget https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.2-1-2c0f5a1_all.deb -P /tmp/
	dpkg -i /tmp/logstash_1.4.2-1-2c0f5a1_all.deb
	sleep 10
fi

dpkg -l | grep redis
if ! [ $? -eq 0 ]
then 
	echo "Installing a broker [Redis] ... "
	apt-get -y update
	apt-get -y install redis-server
	echo "Configuring redis server"
	sed -i 's|bind 127.0.0.1|#bind 127.0.0.1|g' /etc/redis/redis.conf
	sudo /etc/init.d/redis-server force-reload
	sleep 10
fi

dpkg -l | grep elasticsearch
if ! [ $? -eq 0 ]
then 
	echo "Installing elasticsearch ... "
	wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.0.deb -P /tmp/
	dpkg -i /tmp/elasticsearch-1.4.0.deb
	echo "Configuring elasticsearch ... "
	sed -i 's|#cluster.name: elasticsearch|cluster.name: logstash|g' /etc/elasticsearch/elasticsearch.yml
	sed -i 's|#node.name: "Franz Kafka"|node.name: "Simon Takite"|g' /etc/elasticsearch/elasticsearch.yml
	/etc/init.d/elasticsearch restart
fi

echo "Creating central configuration ... "

touch /etc/logstash/central.conf
touch /var/log/logstash/logstash-init.log
touch /var/log/elasticsearch/elasticsearch-service.log
touch /var/log/elasticsearch/elasticsearch-init.log

cat <<EOF>> /etc/logstash/central.conf
input {
	redis {
		host =>"192.168.2.10"
		type => "redis-input"
		data_type => "list"
		key => "logstash"
	}
}

output {
	stdout { }
	elasticsearch {
		cluster => "logstash"
	}
} 
EOF

# setup sudoers
wget "https://raw.githubusercontent.com/simontakite/ELK-playground/master/sudoers" -P /tmp/
mv /tmp/sudoers /etc/sudoers

# setup bashrc
wget "https://raw.githubusercontent.com/simontakite/ELK-playground/master/bashrc" -P /tmp/
mv /tmp/bashrc /home/vagrant/.bashrc

# setup logstash service
wget "https://raw.githubusercontent.com/simontakite/ELK-playground/master/logstash-init.sh" -P /tmp/
mv /tmp/logstash-init.sh /etc/init.d/

chmod +x /etc/init.d/logstash-init.sh
update-rc.d logstash-init.sh start 20 2 3 4 5 . stop 20 0 1 6 .

# setup elastic search service
wget "https://raw.githubusercontent.com/simontakite/ELK-playground/master/elasticsearch-init.sh" -P /tmp/
mv /tmp/elasticsearch-init.sh /etc/init.d/
chmod +x /etc/init.d/elasticsearch-init.sh
update-rc.d elasticsearch-init.sh start 20 2 3 4 5 . stop 20 0 1 6 .

# Generate locale
locale-gen nb_NO.UTF-8
dpkg-reconfigure locales

sleep 10
echo "Restarting ... "
reboot -f now
