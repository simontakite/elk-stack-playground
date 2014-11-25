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

wget "https://raw.githubusercontent.com/simontakite/ELK-playground/master/sudoers" -P /tmp/
mv /tmp/sudoers /etc/sudoers
wget "https://raw.githubusercontent.com/simontakite/ELK-playground/master/bashrc" -P /tmp/
mv /tmp/bashrc /home/vagrant/.bashrc
