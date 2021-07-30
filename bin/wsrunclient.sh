#!/bin/sh

DIRNAME=`dirname $0`
PROGNAME=`basename $0`

if [ $# -eq 0 ]; then
    echo "$PROGNAME is a command line tool that invokes a JBossWS JAX-WS Web Service client."
    echo "It builds the correct classpath and endorsed libs for you. Feel free to use"
    echo "the code for this script to make your own shell scripts. It is open source"
    echo "after all."
    echo 
    echo "usage: $PROGNAME [-classpath <additional class path>] <java-main-class> [arguments...]"
    exit 1;
fi

# OS specific support (must be 'true' or 'false').
cygwin=false;
case "`uname`" in
    CYGWIN*)
        cygwin=true
        ;;
esac

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
    [ -n "$JBOSS_HOME" ] &&
        JBOSS_HOME=`cygpath --unix "$JBOSS_HOME"`
    [ -n "$JAVA_HOME" ] &&
        JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
fi

while [ $# -ge 1 ]; do
   case $1 in
       "-classpath") WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$2"; shift;;
       *) args=$args" $1";;
   esac
   shift
done

# Setup JBOSS_HOME
if [ "x$JBOSS_HOME" = "x" ]; then
    # get the full path (without any relative bits)
    JBOSS_HOME=`cd $DIRNAME/..; pwd`
fi
export JBOSS_HOME

# Setup the JVM
if [ "x$JAVA" = "x" ]; then
    if [ "x$JAVA_HOME" != "x" ]; then
	JAVA="$JAVA_HOME/bin/java"
    else
	JAVA="java"
    fi
fi

#JPDA options. Uncomment and modify as appropriate to enable remote debugging .
#JAVA_OPTS="-classic -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n $JAVA_OPTS"

# Setup JBoss sepecific properties
JAVA_OPTS="$JAVA_OPTS"

# Setup the java endorsed dirs
JBOSS_ENDORSED_DIRS="$JBOSS_HOME/lib/endorsed"

# Setup the tool classpath
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/activation.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/javassist.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jaxb-api.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jaxb-impl.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jbossall-client.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jboss-xml-binding.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jbossws-common.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jbossws-native-client.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jbossws-native-core.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jbossws-native-jaxrpc.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jbossws-native-jaxws.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jbossws-native-jaxws-ext.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jbossws-native-saaj.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/jbossws-spi.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/FastInfoset.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/log4j.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/mail.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/policy.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/stax-api.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/xmlsec.jar"
WSRUNCLIENT_CLASSPATH="$WSRUNCLIENT_CLASSPATH:$JBOSS_HOME/client/wsdl4j.jar"

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
    JBOSS_HOME=`cygpath --path --windows "$JBOSS_HOME"`
    JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
    WSRUNCLIENT_CLASSPATH=`cygpath --path --windows "$WSRUNCLIENT_CLASSPATH"`
    JBOSS_ENDORSED_DIRS=`cygpath --path --windows "$JBOSS_ENDORSED_DIRS"`
fi

# Execute the command
"$JAVA" $JAVA_OPTS \
   -Djava.endorsed.dirs="$JBOSS_ENDORSED_DIRS" \
   -classpath "$WSRUNCLIENT_CLASSPATH" \
   $args
