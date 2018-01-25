#!/bin/bash
#
# rundeckd    Startup script for the rundeck

# Source function library
. /lib/lsb/init-functions
. /etc/rundeck/profile

prog="rundeckd"
PIDFILE=/var/run/$prog.pid
DAEMON="${JAVA_HOME:-/usr}/bin/java"
DAEMON_ARGS="${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck 4440"
rundeckd="$DAEMON $DAEMON_ARGS"

function shutdown()
{
    echo -n "`date +"%d.%m.%Y %T.%3N"` - Stopping ${prog}"
    killproc -p $PIDFILE "$rundeckd"
}

echo -n "`date +"%d.%m.%Y %T.%3N"` - Starting ${prog}"
cd /var/log/rundeck
nohup su -s /bin/bash rundeck -c "$rundeckd" 2>&1 /dev/stdout &
PID=$!
echo $PID > $PIDFILE

trap shutdown HUP INT QUIT ABRT KILL ALRM TERM TSTP

wait `cat ${PIDFILE}`