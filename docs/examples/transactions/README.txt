
JTS
---

To remove the default JTA implementation of the transaction service and replace it with the JTS for
full distributed transaction support, run 'ant jts' or follow the steps below.

- By default the transaction libraries are installed in JBOSS_HOME/common/lib and used by every server configuration.
  Each server configuration has its own transaction config file, JBOSS_HOME/server/<config>/conf/jbossts-properties.xml

- To replace the JTA with JTS for a single server <config> dir:
  For each server using the JTS, delete JBOSS_HOME/server/<config>/conf/jbossts-properties.xml
  and copy jbossts-properties.xml from this dir to JBOSS_HOME/server/<config>/conf/ instead.

 - complete the installation by making the following edits to the server configuration
    (These are difficult to automate with ant and hence are manual steps for now)

 - edit the conf/jbossts-properties.xml file and remove the
   recovery extension property containing the value
   "com.arjuna.ats.internal.jta.recovery.arjunacore.XARecoveryModule"

 - In deploy/transaction-jboss-beans.xml, update the TransactionManager class and dependencies as follows:

    <bean name="TransactionManager" class="com.arjuna.ats.jbossatx.jts.TransactionManagerService">
        <annotation>@org.jboss.aop.microcontainer.aspects.jmx.JMX(name="jboss:service=TransactionManager",
            exposedInterface=com.arjuna.ats.jbossatx.jts.TransactionManagerServiceMBean.class, registerDirectly=true)
        </annotation>

        ...
        <start>
           <parameter><inject bean="jboss:service=CorbaORB" property="ORB"/></parameter>
        </start>
        ...
    </bean>

 - Edit the conf/jacorb.properies as follows.
  - change the jacorb.poa.thread_pool_max property to 32

 - Edit the deploy/iiop-service.xml and modify the
   PortableInterceptorInitializers attribute as follows.
  - remove the following lines
         <!-- comment out to disable null transaction propagation over IIOP -->
         <initializer>org.jboss.tm.iiop.TxServerClientInterceptorInitializer</initializer>
         <!-- comment out to disable transaction demarcation over IIOP -->
         <initializer>org.jboss.tm.iiop.TxServerInterceptorInitializer</initializer>
  - add the following lines
         <!-- JBoss TS interceptor. -->
         <initializer>com.arjuna.ats.jts.orbspecific.jacorb.interceptors.interposition.InterpositionORBInitializerImpl</initializer>
         <!-- RMI/IIOP tx context interceptor -->
         <initializer>com.arjuna.ats.jbossatx.jts.InboundTransactionCurrentInitializer</initializer>

For each deployment of JacORB, you will need to ensure that the jacorb.implname in the jacorb.properties
file is unique.

If running an external recovery manager, edit conf/jbossts-properties.xml to remove
the recovery activator property named "com.arjuna.ats.arjuna.recovery.recoveryActivator_1".
This may be necessary in cluster setups where the ObjectStore is shared, as
there should be only one recovery manager per ObjectStore.

Finally, note that the application server binds to the
localhost address by default. This is generally inappropriate for distributed transactions,
so please ensure the server is bound to a alternative address.

There is a short article on the JBoss wiki that describes some typical JTS
usage scenarios. It is available at the url https://www.jboss.org/community/docs/DOC-13179


XTS (Web Services Transactions)
-------------------------------

Install XTS to the desired server by running 'ant xts' or following the steps below.

- Unzip the jbossxts.sar file into a directory server/<config>/deploy/jbossxts.sar/

Embedded Tools
--------------

WARNING: The tools are a prototype and unsupported component, aimed at providing diagnostic information
regarding the status of transactions, particularly for crash recovery. The tools currently use swing, so are
suitable only for use from the local host and not in remote or headless situations.

Install the tools using 'ant tools' or by following the steps below.

- Copy the jbossts-tools.jar file to server/<config>/deploy/

The tools swing GUI can then be started from the server's JMX console.
