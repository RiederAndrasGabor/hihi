#!/bin/sh

if [ "$#" -ne 1 ]; then
	echo "You must give a module name for argument!"
else
	sudo salt-call state.sls $1 --local \
                                    --file-root=/home/$USER/salt/salt \
                                    --pillar-root=/home/$USER/salt/pillar
fi

