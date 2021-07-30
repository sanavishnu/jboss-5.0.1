JBoss LoggingMonitor Service
----------------------------

--- $Id: readme.txt 34684 2005-08-07 12:32:47Z dimitris $ ----

INTRODUCTION

The JBoss LoggingMonitor service is similar in purpose to the other monitoring
services provided as a part of JBossAS.  The JBoss LoggingMonitor service
monitor's the specified attributes of a MBean periodically and logs their value
to the filename specified.  This file can then be used for debugging and/or
charting JBoss services information based upon your specific use case(s).

The JBoss LoggingMonitor service graduated succesfully from the
"JBoss World Of MBeans", to the jboss codebase. You can read more
about this here: http://www.jboss.org/wiki/Wiki.jsp?page=JBossWorldOfMBeans.

Additional information about the service maybe found in the JBoss wiki:
http://wiki.jboss.org/wiki/Wiki.jsp?page=JBossLoggingMonitor

Questions regarding the use of the JBoss LoggingMonitor service should be
directed to the "Management, JMX/JBoss" user forum.

INSTALLATION/USE

Place the ./lib/logging-monitor.jar file in the lib directory of your JBoss server
configuration, and hot-deploy your customized *-service.xml file to your server
configuration's deploy directory.  Multiple *-service.xml files can be deployed
simultaneously utilizing this MBean.  Examples of various *-service.xml files
can be found in the ./deploy subdirectory.

*-SERVICE.XML FILE FORMAT

The JBoss LoggingMonitor service MBean's configuration file format is the same
as most JBoss MBean services.  Its DTD is specified at
http://www.jboss.org/j2ee/dtd/jboss-service_4_0.dtd.

The following is a description of the attributes and their possible values:

Attribute         Description
---------         -----------

Filename          The name of the file to which monitoring information will be
                  logged.  This attribute can not be set to null or the be
                  empty.

AppendToFile      Whether or not a monitor's log file should have information
                  appended to it, if it already exists.  This attribute is *not*
                  required, and the default value is "true".

PatternLayout     Controls the org.apache.log4j.PatternLayout for logging entries.
                  The default pattern is "%d %-5p [%c] %m%n".

RolloverPeriod    The rollover period for the monitor's log file.  Valid values
                  are MONTH, WEEK, DAY, HALFDAY, HOUR, and MINUTE (case
                  insensitive).  This attribute is *not* required, and the
                  default value is DAY.

MonitoredObjects  The list of objects (MBeans) and their corresponding
                  attributes to be monitored.

                  This parameter is specified as a XML fragment as follows:

                  <configuration>
                     <monitoredmbean name="[object name]"
                                     logger="[logger name]">
                        <attribute>[attribute name]</attribute>
                        <attribute>[attribute name]</attribute>
                        ...
                     </monitoredmbean>
                     ...
                  </configuration>

                  [object name] is the name of the MBean to be monitored.

                  [logger name] the name of the logger to be used when logging
                                attribute information.

                  [attribute name] the name of an attribute to be logged.

                  As the XML fragment indicates, any number of MBeans can be
                  monitored, and any number of attributes for a given MBean can
                  be specified.

MonitorPeriod     The frequency with which to log information (in milliseconds).
                  This attribute must have a non-zero, positive value.

AUTHORS

James Wilson, original code
Dimitris Andreadis, integration into the jboss codebase                  

