#!/bin/sh
#
#  JBoss Password Tool
#
################################

DIRNAME=`dirname $0`
PROGNAME=`basename $0`

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
#JAVA_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=y $JAVA_OPTS"

# Setup JBoss sepecific properties
JAVA_OPTS="$JAVA_OPTS"

# Setup the java endorsed dirs
JBOSS_ENDORSED_DIRS="$JBOSS_HOME/lib/endorsed"

###
# Setup the jboss password tool classpath
###

# Shared libs
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JAVA_HOME/lib/tools.jar"
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/client/commons-logging.jar"
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/client/jboss-logging-spi.jar"
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/lib/endorsed/xalan.jar"

# Shared jaxb libs
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/client/activation.jar"
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/client/jaxb-api.jar"
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/client/jaxb-impl.jar"
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/client/stax-api.jar"

# Specific dependencies
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/client/xmlsec.jar"
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/client/jbosssx-client.jar"
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/client/jbosssx-as-client.jar"
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/common/lib/jbosssx.jar"
JBOSSPASS_CLASSPATH="$JBOSSPASS_CLASSPATH:$JBOSS_HOME/common/lib/log4j.jar"

###
# Execute the JVM
###

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
    JBOSS_HOME=`cygpath --path --windows "$JBOSS_HOME"`
    JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
    JBOSSPASS_CLASSPATH=`cygpath --path --windows "$JBOSSPASS_CLASSPATH"`
    JBOSS_ENDORSED_DIRS=`cygpath --path --windows "$JBOSS_ENDORSED_DIRS"`
fi

"$JAVA" $JAVA_OPTS \
   -Djava.endorsed.dirs="$JBOSS_ENDORSED_DIRS" \
   -classpath "$JBOSSPASS_CLASSPATH" \
   org.jboss.security.integration.password.PasswordTool "$@"
