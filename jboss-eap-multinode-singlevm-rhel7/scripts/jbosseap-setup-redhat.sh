#!/bin/sh

/bin/date +%H:%M:%S >> install.progress.txt
echo "Red Hat JBoss EAP 7.2 Installation Start"  >> install.progress.txt

export JBOSS_HOME="/opt/rh/eap7/root/usr/share/wildfly"
NODENAME1="node1"
NODENAME2="node2"
SVR_CONFIG="standalone-ha.xml"
PORT_OFFSET=100
JBOSS_EAP_USER=$1
JBOSS_EAP_PASSWORD=$2
RHEL_OS_LICENSE_TYPE=$3
RHSM_USER=$4
RHSM_PASSWORD=$5
RHSM_POOL=$6
IP_ADDR_NAME=$7
IP_ADDR=$8

STORAGE_ACCOUNT_NAME=$9
STORAGE_ACCESS_KEY=${10}
CONTAINER_NAME="eapblobcontainer"

echo "JBOSS_EAP_USER: " ${JBOSS_EAP_USER} >> install.progress.txt
echo "RHSM_USER: " ${RHSM_USER} >> install.progress.txt
echo "RHSM_POOL: " ${RHSM_POOL} >> install.progress.txt
echo "STORAGE_ACCOUNT_NAME: " ${STORAGE_ACCOUNT_NAME} >> install.progress.txt
echo "STORAGE_ACCESS_KEY: " ${STORAGE_ACCESS_KEY} >> install.progress.txt
echo "CONTAINER_NAME: " ${CONTAINER_NAME} >> install.progress.txt
echo "IP_ADDR_NAME: " ${IP_ADDR_NAME} >> install.progress.txt
echo "IP_ADDR: " ${IP_ADDR} >> install.progress.txt

echo "subscription-manager register..." >> install.progress.txt
subscription-manager register --username ${RHSM_USER} --password ${RHSM_PASSWORD} >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Registration Failed" >> install.progress.txt; exit $flag;  fi
subscription-manager attach --pool=${RHSM_POOL} >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Pool Attach for JBoss EAP Failed" >> install.progress.txt; exit $flag;  fi
if [ $RHEL_OS_LICENSE_TYPE == "BYOS" ] 
then 
    echo "Attaching Pool ID for RHEL OS" >> install.progress.txt
    subscription-manager attach --pool=${11} >> install.out.txt 2>&1
    flag=$?; if [ $flag != 0 ] ; then echo  "Pool Attach for RHEL OS Failed" >> install.progress.txt; exit $flag;  fi
fi
subscription-manager repos --enable=jb-eap-7-for-rhel-7-server-rpms >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Enabling repos for JBoss EAP Failed" >> install.progress.txt; exit $flag;  fi

echo "JBoss EAP RPM installing..." >> install.progress.txt
yum-config-manager --disable rhel-7-server-htb-rpms 
yum groupinstall -y jboss-eap7 >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "JBoss EAP installation Failed" >> install.progress.txt; exit $flag;  fi

echo "Create 2 JBoss EAP nodes on Azure..." >> install.progress.txt
/bin/cp  -rL  $JBOSS_HOME/standalone $JBOSS_HOME/$NODENAME1 >> install.out.txt 2>&1
/bin/cp  -rL  $JBOSS_HOME/standalone $JBOSS_HOME/$NODENAME2 >> install.out.txt 2>&1

echo "Eap session replication app deploy..." >> install.progress.txt
yum install -y git >> install.out.txt 2>&1
git clone https://github.com/Suraj2093/eap-session-replication.git >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Git clone Failed" >> install.progress.txt; exit $flag;  fi
/bin/cp -rf ./eap-session-replication/eap-configuration/standalone-ha.xml $JBOSS_HOME/$NODENAME1/configuration/ >> install.out.txt 2>&1
/bin/cp -rf ./eap-session-replication/eap-configuration/standalone-ha.xml $JBOSS_HOME/$NODENAME2/configuration/ >> install.out.txt 2>&1
/bin/cp -rf ./eap-session-replication/target/eap-session-replication.war $JBOSS_HOME/$NODENAME1/deployments/eap-session-replication.war >> install.out.txt 2>&1
/bin/cp -rf ./eap-session-replication/target/eap-session-replication.war $JBOSS_HOME/$NODENAME2/deployments/eap-session-replication.war >> install.out.txt 2>&1
touch $JBOSS_HOME/$NODENAME1/deployments/eap-session-replication.war.dodeploy >> install.out.txt 2>&1
touch $JBOSS_HOME/$NODENAME2/deployments/eap-session-replication.war.dodeploy >> install.out.txt 2>&1

echo "Configuring JBoss EAP management user..." >> install.progress.txt
$JBOSS_HOME/bin/add-user.sh -sc $JBOSS_HOME/$NODENAME1/configuration -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup' >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "JBoss EAP management user configuration for Node 1 Failed" >> install.progress.txt; exit $flag;  fi
$JBOSS_HOME/bin/add-user.sh -sc $JBOSS_HOME/$NODENAME2/configuration -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup' >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "JBoss EAP management user configuration Node 2 Failed" >> install.progress.txt; exit $flag;  fi

echo "Start JBoss EAP 7.2 instances..." >> install.progress.txt 
$JBOSS_HOME/bin/standalone.sh -Djboss.node.name=$NODENAME1 -Djboss.server.base.dir=$JBOSS_HOME/$NODENAME1 -c $SVR_CONFIG -b $IP_ADDR -bmanagement $IP_ADDR -bprivate $IP_ADDR -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME & >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Starting JBoss EAP service Failed for Node 1" >> install.progress.txt; exit $flag;  fi
$JBOSS_HOME/bin/standalone.sh -Djboss.node.name=$NODENAME2 -Djboss.server.base.dir=$JBOSS_HOME/$NODENAME2 -c $SVR_CONFIG -b $IP_ADDR -bmanagement $IP_ADDR -bprivate $IP_ADDR -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djboss.socket.binding.port-offset=$PORT_OFFSET & >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Starting JBoss EAP service Failed for Node 2" >> install.progress.txt; exit $flag;  fi

echo "Configure firewall for ports 8080, 8180, 9990, 10090..." >> install.progress.txt
firewall-cmd --zone=public --add-port=8080/tcp --permanent >> install.out.txt 2>&1
firewall-cmd --zone=public --add-port=8180/tcp --permanent >> install.out.txt 2>&1
firewall-cmd --zone=public --add-port=9990/tcp --permanent >> install.out.txt 2>&1
firewall-cmd --zone=public --add-port=10090/tcp --permanent >> install.out.txt 2>&1
firewall-cmd --reload >> install.out.txt 2>&1

echo "Open Red Hat software firewall for port 22..." >> install.progress.txt
firewall-cmd --zone=public --add-port=22/tcp --permanent >> install.out.txt 2>&1
firewall-cmd --reload >> install.out.txt 2>&1

# Seeing a race condition timing error so sleep to delay
sleep 20

echo "Red Hat JBoss EAP 7.2 Intallation End " >> install.progress.txt
/bin/date +%H:%M:%S >> install.progress.txt