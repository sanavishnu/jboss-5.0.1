<%@ page import="
java.net.URLEncoder,
java.util.Map,
javax.management.MBeanServer,
javax.management.ObjectName,
javax.management.Notification,
org.jboss.util.Strings,
org.jboss.mx.util.MBeanServerLocator,
org.jboss.monitor.alarm.Alarm,
org.jboss.monitor.alarm.AlarmHelper,
org.jboss.monitor.alarm.AlarmNotification,
org.jboss.monitor.alarm.AlarmTableNotification,
org.jboss.monitor.services.ActiveAlarmTableMBean
"%>
 <%--
 | Show the ActiveAlarmTable
 |
 | Author: Dimitris Andreadis (dimitris@jboss.org)
 |
 | Distributable under LGPL license.
 | See terms of license at gnu.org.
 +--%>
<%
try
{
%>
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
   <title>JBoss Management Console - Active Alarm Table</title>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
   <link rel="StyleSheet" href="css/jboss.css" type="text/css"/>
</head>

<body>
<!-- header begin -->
   <img src="images/logo.gif" alt="JBoss" id="logo" width="226" height="105" />
   <div id="header">&nbsp;</div>
   <div id="navigation_bar"/>
<!-- header end -->
<hr class="hide"/>
   <center>
   <div id="content">
      <div class="content_block" style="width: 100%; height: 247">
         <h3>Active Alarm Table</h3>
<%
   MBeanServer server = MBeanServerLocator.locateJBoss();
   ObjectName target = ActiveAlarmTableMBean.OBJECT_NAME;
   AlarmTableNotification[] altab = (AlarmTableNotification[])server.invoke(target, "fetchAlarmTable", new Object[] {}, new String[] {});

   // get some statistics from the table
   Map stats = AlarmHelper.getAlarmTableNotificationStats(altab);
   Integer stateCleared = (Integer)stats.get(AlarmHelper.getStateAsString(Alarm.STATE_CLEARED));
   Integer stateChanged = (Integer)stats.get(AlarmHelper.getStateAsString(Alarm.STATE_CHANGED));
   Integer stateCreated = (Integer)stats.get(AlarmHelper.getStateAsString(Alarm.STATE_CREATED));
   Integer stateNone    = (Integer)stats.get(AlarmHelper.getStateAsString(Alarm.STATE_NONE));
   Integer severityNormal   = (Integer)stats.get(AlarmHelper.getSeverityAsString(Alarm.SEVERITY_NORMAL));
   Integer severityWarning  = (Integer)stats.get(AlarmHelper.getSeverityAsString(Alarm.SEVERITY_WARNING));
   Integer severityMinor    = (Integer)stats.get(AlarmHelper.getSeverityAsString(Alarm.SEVERITY_MINOR));
   Integer severityMajor    = (Integer)stats.get(AlarmHelper.getSeverityAsString(Alarm.SEVERITY_MAJOR));
   Integer severityCritical = (Integer)stats.get(AlarmHelper.getSeverityAsString(Alarm.SEVERITY_CRITICAL));
   Integer severityUnknown  = (Integer)stats.get(AlarmHelper.getSeverityAsString(Alarm.SEVERITY_UNKNOWN));
   int statefullCount = altab.length - stateNone.intValue();
%>
<p>&nbsp;</p>
<center>
   Alarm Count: <%=altab.length%><br>
   (Stateless: <%=stateNone%>, Statefull: <%=statefullCount%>)<br><br>
   <table class="data_table">
   <tr>
      <th width="50%" align="left">Alarm State</th>
      <th width="50%" align="left">Alarm Severity</th>
   </tr>
   <tr>
      <td>
      NONE: <%=stateNone%><br>
      CREATED: <%=stateCreated%><br>
      CHANGED: <%=stateChanged%><br>
      CLEARED: <%=stateCleared%>
      </td>
      <td>
      UNKNOWN: <%=severityUnknown%><br>
      CRITICAL: <%=severityCritical%><br>
      MAJOR: <%=severityMajor%><br>
      MINOR: <%=severityMinor%><br>
      WARNING: <%=severityWarning%><br>
      NORMAL: <%=severityNormal%>
      </td>
   </tr>
   </table>
 <form action="listActiveAlarmTable.jsp" method="post" align="middle">
   <input type="submit" name="action" value="Refresh Table">
</form>
</center>
<table class="data_table" cellspacing="2" cellpadding="2" border="1" >
<tr>
   <th width="150">AlarmInfo</th>
   <th>NotificationInfo</th>
</tr>
<%
   for (int i = 0; i < altab.length; i++)
   {
      AlarmTableNotification atn = altab[i];

      String alarmId = atn.getAlarmId();
      String severity = AlarmHelper.getSeverityAsString(atn.getSeverity());
      String alarmState = AlarmHelper.getStateAsString(atn.getAlarmState());
      boolean ackState = atn.getAckState();
      long ackTime = atn.getAckTime();
      String ackUser = atn.getAckUser();
      String ackSystem = atn.getAckSystem();

      Notification n = (Notification)atn.getUserData();
      Object source = AlarmNotification.getEffectiveSource(n);
      String sourceLink = "/jmx-console/HtmlAdaptor?action=inspectMBean&name=" + URLEncoder.encode(source.toString());
      String type = n.getType();
      long timeStamp = n.getTimeStamp();
      long sequenceNumber = n.getSequenceNumber();
      String message = (n.getMessage() != null) ? Strings.subst("\n", "<br>", n.getMessage()) : "null";
      String userData = (n.getUserData() != null) ? Strings.subst("\n", "<br>", n.getUserData().toString()) : "null";
%>
<tr>
   <td>
      alarmId: <font color="navy"><%=alarmId%></font><br><br>
      severity: <font color="fuchsia"><%=severity%></font><br>
      alarmState: <font color="fuchsia"><%=alarmState%></font><br><br>
      ackState: <font color="navy"><%=ackState%></font><br><br>
      actTime: <font color="navy"><%=ackTime%></font><br>
      ackUser: <font color="navy"><%=ackUser%></font><br>
      ackSystem: <font color="navy"><%=ackSystem%></font>
      <form action="AcknowledgeActiveAlarms" method="post">
         <input type="hidden" name="alarmId" value="<%=alarmId%>">
         <input type="submit" name="action" value="Ack">
      </form>
   </td>
   <td>
      source: <a href="<%=sourceLink%>"><%=source%></a><br>
      type: <font color="navy"><%=type%></font><br>
      timeStamp: <font color="navy"><%=timeStamp%></font><br>
      sequenceNumber: <font color="navy"><%=sequenceNumber%></font><br><br>
      message: <font color="navy"><%=message%></font><br><br>
      userData: <font color="navy"><%=userData%></font>
   </td>
</tr>
<% 
   }
%>
</table>
<form action="AcknowledgeActiveAlarms" method="post">
   <input type="hidden" name="alarmId" value="*">
   <input type="submit" name="action" value="Acknowledge All Alarms">
</form>
<%
}
catch (Exception ex)
{
   %> ERROR in parsing <%
   ex.printStackTrace();
}
%>
      </div>
   <div class="spacer"><hr/></div>
   </div>
</center>
<!-- content end -->
<hr class="hide"/>
<!-- footer begin -->
<div id="footer">
   <div id="credits">JBoss&trade; Management Console</div>
   <div id="footer_bar">&nbsp;</div>
</div>
<!-- footer end -->
</body>
</html>
