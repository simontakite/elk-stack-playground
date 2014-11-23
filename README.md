# VAGRANT-ELK

Dans le but de faire un POC ELK, il suffit juste de rajouter les fichiers de
logs dans le dossier data/idm.

Par contre, il faudra faire attention aux noms des fichiers de logs.


# Pré-requis technique
Il faut les logiciels suivants :

* [GIT](http://www.git-scm.com)
* [VirtualBox](http://www.virtualbox.org)
* [Vagrant](http://www.vagrantup.com)

# Utilisation
## Cloner le repository __vagrant-elk__

    git clone git@github.com:rsareth/vagrant-elk.git

## Lancer la VM depuis une console
_Remarque importante :_ Pour ceux qui ont le malheure d’être sous Windows, lancer
une _commande dos_ et assurer d’avoir la commande _vagrant_ dans la variable _Path_.

    cd <CHEMIN>/vagrant-elk
    vagrant up

## Arrêter la VM
Sur le même principe que le point précédent, il suffit juste de taper ceci :

	vagrant halt

## Connexion SSH dans la VM

    cd <CHEMIN>/vagrant-elk
    vagrant ssh

## Accéder au Kibana depuis votre navigateur
_Remarque importante :_ Pour ceux qui ont en plus d’avoir le malheur d’être sous
Windows et d’utiliser Internet Explorer, assurez-vous d’avoir au moins la
version 9.

Allez sur cette URL : [Kibana local](http://localhost:7069/kibana)

# Configuration
## Logstash
Le fichier de configuration est dans <CHEMIN>/vagrant-elk/data/conf/logstash/logstash.conf

__Attention__, il est bien présent sur votre système hôte et non invité.

Modifiez le avec votre éditeur de texte favori.
Pour prendre en compte les modifications :

* connectez-vous en ssh (vagrant ssh)
* saisissez ceci :

	cd /vagrant_data/scripts
	sh logstash.sh start # pour démarrer

## Elasticsearch
A REDIGER QUAND JE SERAI ARRIVE A CETTE ETAPE.

Les fichiers de configuration sont directement dans la VM donc se connecter en ssh (vagrant ssh).
Les fichiers sont dans __/etc/elasticsearch/__
