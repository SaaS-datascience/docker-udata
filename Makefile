##############################################
# WARNING : THIS FILE SHOULDN'T BE TOUCHED   #
#    FOR ENVIRONNEMENT CONFIGURATION         #
# CONFIGURABLE VARIABLES SHOULD BE OVERRIDED #
# IN THE 'artifacts' FILE, AS NOT COMMITTED  #
##############################################

EDITOR=vim

export PORT=80
export NETWORK=latelier

include /etc/os-release

dummy               := $(shell touch artifacts)
include ./artifacts

install-theme:
ifeq ("$(wildcard udata-lecatalogue-theme/lecatalogue)","")
	@echo getting theme for le catalogue
	git clone https://github.com/SaaS-datascience/udata-lecatalogue-theme
endif

install-prerequisites:
ifeq ("$(wildcard /usr/bin/docker)","")
        @echo install docker-ce, still to be tested
        sudo apt-get update
        sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

        curl -fsSL https://download.docker.com/linux/${ID}/gpg | sudo apt-key add -
        sudo add-apt-repository \
                "deb https://download.docker.com/linux/ubuntu \
                `lsb_release -cs` \
                stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce
        sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
endif

network: 
	@docker network create ${NETWORK} 2> /dev/null; true


up: network install-theme
	docker-compose up -d

down:
	docker-compose down

restart: down up
