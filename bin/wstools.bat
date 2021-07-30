@echo off

@if not "%ECHO%" == ""  echo %ECHO%
@if "%OS%" == "Windows_NT"  setlocal

set DIRNAME=.\
if "%OS%" == "Windows_NT" set DIRNAME=%~dp0%
set PROGNAME=run.bat
if "%OS%" == "Windows_NT" set PROGNAME=%~nx0%

set JAVA=%JAVA_HOME%\bin\java
if "%JBOSS_HOME%" == "" set JBOSS_HOME=%DIRNAME%\..

rem Setup the java endorsed dirs
set JBOSS_ENDORSED_DIRS=%JBOSS_HOME%\lib\endorsed

rem Setup the wstools classpath
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JAVA_HOME%/lib/tools.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/activation.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/getopt.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/wstx.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/wsdl4j.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/jbossall-client.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/log4j.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/mail.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/concurrent.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/jbossws-spi.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/jbossws-common.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/javassist.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/jboss-xml-binding.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/jbossws-native-client.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/jbossws-native-core.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/jbossws-native-jaxws.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/jbossws-native-jaxrpc.jar
set WSTOOLS_CLASSPATH=%WSTOOLS_CLASSPATH%;%JBOSS_HOME%/client/jbossws-native-saaj.jar

rem Display our environment
echo ========================================================================="
echo . 
echo   WSTools Environment
echo .
echo   JBOSS_HOME: %JBOSS_HOME%
echo .
echo   JAVA: %JAVA%
echo .
echo   JAVA_OPTS: %JAVA_OPTS%
echo .
rem echo   CLASSPATH: %WSTOOLS_CLASSPATH%
rem echo .
echo ========================================================================="
echo .

rem Execute the command
"%JAVA%" %JAVA_OPTS% -Djava.endorsed.dirs="%JBOSS_ENDORSED_DIRS%" -classpath "%WSTOOLS_CLASSPATH%" org.jboss.ws.tools.WSTools %*
