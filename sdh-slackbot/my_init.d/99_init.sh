#!/bin/sh


SDHNAME="sdh-slackbot"

Update() {
    ROOT=$(pwd)
    cd /home/
    VC_DIR=$1/.git
    if [ ! -d $VC_DIR ]
    then
        echo "Repository is not present, need to clone."
        git clone $2 $1
        cd $1
        echo "> Installing npm dependencies"
        npm install --unsafe-perm
    else
        echo "Pulling..."
        cd $1
        git pull
        echo "> Updating npm dependencies"
        npm update --unsafe-perm
    fi

    echo "> Starting Bot"
    Start

    cd $ROOT
}

Start() {

    echo -n "> Waiting for elasticsearch to be ready..."
    while ! nc -z elasticsearch 9200; do sleep 2; done
    echo "done!"

    # Start the service
    npm start &
}

echo "> SDH Slackbot"
Update $SDHNAME https://github.com/smartdeveloperhub/$SDHNAME.git

