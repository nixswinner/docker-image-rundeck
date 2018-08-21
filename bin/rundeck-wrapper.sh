#!/bin/bash
#
# rundeckd    Startup script for the rundeck

# Source function library
. /lib/lsb/init-functions
. /etc/rundeck/profile

prog="rundeckd"
PIDFILE=/var/run/$prog.pid

function shutdown()
{
    echo -n "`date +"%d.%m.%Y %T.%3N"` - Stopping ${prog}"
    killproc -p $PIDFILE "$rundeckd"
}

echo -n "`date +"%d.%m.%Y %T.%3N"` - Starting ${prog}"
cd /var/log/rundeck

# $rundeckd is populated in /etc/rundeck/profile
nohup su -s /bin/bash rundeck -c "$rundeckd" 2>&1 /dev/stdout &
PID=$!
echo $PID > $PIDFILE

trap shutdown HUP INT QUIT ABRT KILL ALRM TERM TSTP

wait `cat ${PIDFILE}`