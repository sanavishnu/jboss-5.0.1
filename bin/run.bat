@echo off
rem -------------------------------------------------------------------------
rem JBoss Bootstrap Script for Windows
rem -------------------------------------------------------------------------

rem $Id: run.bat 88978 2009-05-16 18:18:45Z alex.loubyansky@jboss.com $

@if not "%ECHO%" == ""  echo %ECHO%
@if "%OS%" == "Windows_NT" setlocal

if "%OS%" == "Windows_NT" (
  set "DIRNAME=%~dp0%"
) else (
  set DIRNAME=.\
)

rem Read an optional configuration file.
if "x%RUN_CONF%" == "x" (   
   set "RUN_CONF=%DIRNAME%run.conf.bat"
)
if exist "%RUN_CONF%" (
   echo Calling %RUN_CONF%
   call "%RUN_CONF%" %*
) else (
   echo Config file not found %RUN_CONF%
)

pushd %DIRNAME%..
if "x%JBOSS_HOME%" == "x" (
  set "JBOSS_HOME=%CD%"
)
popd

set DIRNAME=

if "%OS%" == "Windows_NT" (
  set "PROGNAME=%~nx0%"
) else (
  set "PROGNAME=run.bat"
)

if "x%JAVA_OPTS%" == "x" (
  set "JAVA_OPTS=-Dprogram.name=%PROGNAME%"
) else (
  set "JAVA_OPTS=-Dprogram.name=%PROGNAME% %JAVA_OPTS%"
)

if "x%JAVA_HOME%" == "x" (
  set  JAVA=java
  echo JAVA_HOME is not set. Unexpected results may occur.
  echo Set JAVA_HOME to the directory of your local JDK to avoid this message.
) else (
  set "JAVA=%JAVA_HOME%\bin\java"
  if exist "%JAVA_HOME%\lib\tools.jar" (
    set "JAVAC_JAR=%JAVA_HOME%\lib\tools.jar"
  )
)

rem Add -server to the JVM options, if supported
"%JAVA%" -server -version 2>&1 | findstr /I hotspot > nul
if not errorlevel == 1 (
  set "JAVA_OPTS=%JAVA_OPTS% -server"
)

rem Set Java platform if 64-Bit JVM used
set JAVA_PLATFORM=
"%JAVA%" -version 2>&1 | findstr /I "64-Bit ^| x86_64" > nul
if not errorlevel == 1 (
  if /I "%PROCESSOR_ARCHITECTURE%"=="IA64"  (set JAVA_PLATFORM=i64
  ) else if /I "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set JAVA_PLATFORM=x64
  ) else if /I "%PROCESSOR_ARCHITECTURE%"=="x64"   (set JAVA_PLATFORM=x64
  ) else if /I "%PROCESSOR_ARCHITEW6432%"=="IA64"  (set JAVA_PLATFORM=i64
  ) else if /I "%PROCESSOR_ARCHITEW6432%"=="AMD64" (set JAVA_PLATFORM=x64
  ) else (
    echo PROCESSOR_ARCHITECTURE is not set. Unexpected results may occur.
    echo Set PROCESSOR_ARCHITECTURE according to the 64-Bit JVM used.
  )
)

if "x%JAVA_PLATFORM%" == "x" set JAVA_PLATFORM=x86

rem Add native to the PATH if present
set JBOSS_NATIVE_LOC=
if exist "%JBOSS_HOME%\bin\META-INF\lib\windows-%JAVA_PLATFORM%" (
  set "JBOSS_NATIVE_HOME=%JBOSS_HOME%\bin\META-INF\lib\windows-%JAVA_PLATFORM%"
) else if exist "%JBOSS_HOME%\bin\native" (
  set "JBOSS_NATIVE_HOME=%JBOSS_HOME%\bin\native"
)

if not "x%JBOSS_NATIVE_HOME%" == "x" (
  set "PATH=%JBOSS_NATIVE_HOME%;%PATH%;%JBOSS_HOME%\bin"
  set JAVA_OPTS=%JAVA_OPTS% "-Djava.library.path=%JBOSS_NATIVE_HOME%;%PATH%;%JBOSS_HOME%\bin"
)

rem Find run.jar, or we can't continue

if exist "%JBOSS_HOME%\bin\run.jar" (
  if "x%JAVAC_JAR%" == "x" (
    set "RUNJAR=%JAVAC_JAR%;%JBOSS_HOME%\bin\run.jar"
  ) else (
    set "RUNJAR=%JBOSS_HOME%\bin\run.jar"
  )
) else (
  echo Could not locate "%JBOSS_HOME%\bin\run.jar".
  echo Please check that you are in the bin directory when running this script.
  goto END
)

rem If JBOSS_CLASSPATH empty, don't include it, as this will
rem result in including the local directory in the classpath, which makes
rem error tracking harder.
if "x%JBOSS_CLASSPATH%" == "x" (
  set "RUN_CLASSPATH=%RUNJAR%"
) else (
  set "RUN_CLASSPATH=%JBOSS_CLASSPATH%;%RUNJAR%"
)

set JBOSS_CLASSPATH=%RUN_CLASSPATH%

rem Setup JBoss specific properties

rem Setup the java endorsed dirs
set JBOSS_ENDORSED_DIRS=%JBOSS_HOME%\lib\endorsed

echo ===============================================================================
echo.
echo   JBoss Bootstrap Environment
echo.
echo   JBOSS_HOME: %JBOSS_HOME%
echo.
echo   JAVA: %JAVA%
echo.
echo   JAVA_OPTS: %JAVA_OPTS%
echo.
echo   CLASSPATH: %JBOSS_CLASSPATH%
echo.
echo ===============================================================================
echo.

:RESTART
"%JAVA%" %JAVA_OPTS% ^
   -Djava.endorsed.dirs="%JBOSS_ENDORSED_DIRS%" ^
   -classpath "%JBOSS_CLASSPATH%" ^
   org.jboss.Main %*

if ERRORLEVEL 10 goto RESTART

:END
if "x%NOPAUSE%" == "x" pause

:END_NO_PAUSE
