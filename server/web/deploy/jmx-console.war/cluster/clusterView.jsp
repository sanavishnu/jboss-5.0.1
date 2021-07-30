<%@page contentType="text/html" import="java.net.*,java.io.*,java.util.*,org.jboss.jmx.adaptor.control.*,org.jboss.jmx.adaptor.model.*" %>
<html>
<head><title>Clustered JBoss Management Console</title>
<link rel="stylesheet" href="../style_master.css" type="text/css">
</head>

<body>

<table width="235" cellspacing="0" cellpadding="0" border="0">
<tr>
<td align="center" width="235" height="105"><img src="../images/logo.gif" border="0" alt="JBoss"/></td>
</tr>
</table>

&nbsp;

<table width="235" cellspacing="0" cellpadding="0" border="0">
<tr><td><h2>Cluster View Bootstrap</h2></td></tr>
<tr><td><h3><a href="bootstrap.html" target="ClusterNodeView">Reinvoke Bootstrap</a></h3></td></tr>
</table>

&nbsp;

<table width="235" cellspacing="0" cellpadding="0" border="0">
<tr><td><h2>Loaded Clusters</h2></td></tr>
<tr><td><h3><%= request.getAttribute("partition") %></h3></td></tr>
</table>

<table width="235" cellspacing="0" cellpadding="0" border="0">
   <ul>
<%
   String[] partitionHosts = (String[]) request.getAttribute("partitionHosts");
   int      port           =            request.getServerPort();

   for(int h = 0; h < partitionHosts.length; h ++)
   {
      String host = partitionHosts[h];
      String hostname = "";

      try
      {
         hostname = InetAddress.getByName(host).getHostName();
      }
      catch(IOException e)  {}

      String hostURL = "http://"+host+":"+port+"/jmx-console/HtmlAdaptor?action=displayMBeans&filter=";
%>
      <tr><td><li><a href="<%= hostURL%>" target="ClusterNodeView"><%= hostname %></a></li></td></tr>
<%
   }
%>
   </ul>

</table>

&nbsp;

<table width="235" cellspacing="0" cellpadding="0" border="0">
<tr>
<td>
<h2>Object Name Filter</h2>
</td>
</tr>
<tr>
<td>
<h3><a href="../HtmlAdaptor?action=displayMBeans&filter=" target="ClusterNodeView">Remove Object Name Filter</a></h3>
</td>
</tr>
<%
   Iterator mbeans = (Iterator) Server.getDomainData("");
   int i=0;
   while( mbeans.hasNext() )
   {
      DomainData domainData = (DomainData) mbeans.next();
      out.println(" <tr>");
      out.println("  <td>");
      out.println("   <li><a href=\"../HtmlAdaptor?action=displayMBeans&filter="+domainData.getDomainName()+"\" target=\"ClusterNodeView\">"+domainData.getDomainName()+"</a></li>");
      out.println("  </td>");
      out.println(" </tr>");
   }
%>
</table>

</body>
</html>
