#!/bin/bash

if [ "$#" -eq 2 ]; then
	BEFORE_UPDATE_VERSION=$1
	AFTER_UPDATE_VERSION=$2
else
	echo "Usage $0 server-before-upgrade-version server-updated-version"
fi


clone_docker_server(){
	if [ -d "server" ]
        then
                cd server
                git fetch
                git rebase
                cd ..
        else
                git clone https://github.com/owncloud-docker/server.git
        fi
}

clone_populator(){
	if [ -d "populator" ]                                                                                                               
        then
                cd populator
                git fetch
                git rebase
                cd ..
        else
                git clone https://github.com/SergioBertolinSG/populator.git
        fi
}


prepare_environment(){
	clone_docker_server
	clone_populator
	if [ ! -d "death_machine_docker_env" ]
	then
		python3 -m venv death_machine_docker_env
	fi
	source death_machine_docker_env/bin/activate
	curl https://bootstrap.pypa.io/get-pip.py | python
	pip install -r requirements.txt
}

finish_environment(){
	deactivate
	cd server
	docker-compose down
	rm -rf data
	rm -rf mysql
	cd ..
}

### PARAMETERS
#   $1 Server version to install
install_server(){
	cd server
	VERSION=$1 docker-compose up -d
	cd ..
	python3 sanity.py
}

populate_server(){
	python3 populate_server.py
}

### PARAMETERS
#   $1 Server version to upgrade to
upgrade_server(){
	cd server
	VERSION=$1 docker-compose up -d
	cd ..
}

set -e

trap finish_environment EXIT
trap finish_environment ERR


prepare_environment
install_server $BEFORE_UPDATE_VERSION
populate_server
upgrade_server $AFTER_UPDATE_VERSION
