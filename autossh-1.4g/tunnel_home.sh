#!/bin/sh
#
# Example script to start up tunnel with autossh.
#
# This script will tunnel 2200 from the remote host
# to 22 on the local host. On remote host do:
#     ssh -p 2200 localhost
#
# $Id: autossh.host,v 1.6 2004/01/24 05:53:09 harding Exp $
#

ID=Guillaume
HOST=gobbedy.hopto.org

if [ "X$SSH_AUTH_SOCK" = "X" ]; then
    eval `ssh-agent -s`
    ssh-add $HOME/.ssh/id_rsa
fi

#AUTOSSH_POLL=600 
#AUTOSSH_PORT=20000 
#AUTOSSH_GATETIME=30
#AUTOSSH_LOGFILE=$HOST.log
#AUTOSSH_DEBUG=yes 
#AUTOSSH_PATH=/usr/local/bin/ssh
export AUTOSSH_POLL AUTOSSH_LOGFILE AUTOSSH_DEBUG AUTOSSH_PATH AUTOSSH_GATETIME AUTOSSH_PORT

#autossh -2 -fN -M 6022 -R 22222:localhost:22 ${ID}@${HOST}
autossh -M 20000 -f -N -p 6022 -T -R 22222:localhost:22 ${ID}@${HOST}
