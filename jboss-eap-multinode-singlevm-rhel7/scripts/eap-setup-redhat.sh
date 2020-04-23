#!/bin/sh

/bin/date +%H:%M:%S >> /home/$1/install.log
echo "Red Hat JBoss EAP 7.2 Installation Start"  >> /home/$1/install.log

export JBOSS_HOME="/opt/rh/eap7/root/usr/share/wildfly"
NODENAME1="node1"
NODENAME2="node2"
SVR_CONFIG="standalone-ha.xml"
PORT_OFFSET=100
JBOSS_EAP_USER=$2
JBOSS_EAP_PASSWORD=$3
OFFER=$4
RHSM_USER=$5
RHSM_PASSWORD=$6
RHSM_POOL=$7
IP_ADDR_NAME=$8
IP_ADDR=$9

STORAGE_ACCOUNT_NAME=${10}
STORAGE_ACCESS_KEY=${11}
CONTAINER_NAME="eapblobcontainer"

echo "JBOSS_EAP_USER: " ${JBOSS_EAP_USER} >> /home/$1/install.log
echo "RHSM_USER: " ${RHSM_USER} >> /home/$1/install.log
echo "RHSM_POOL: " ${RHSM_POOL} >> /home/$1/install.log
echo "STORAGE_ACCOUNT_NAME: " ${STORAGE_ACCOUNT_NAME} >> /home/$1/install.log
echo "STORAGE_ACCESS_KEY: " ${STORAGE_ACCESS_KEY} >> /home/$1/install.log
echo "CONTAINER_NAME: " ${CONTAINER_NAME} >> /home/$1/install.log
echo "IP_ADDR_NAME: " ${IP_ADDR_NAME} >> /home/$1/install.log
echo "IP_ADDR: " ${IP_ADDR} >> /home/$1/install.log

echo "subscription-manager register..." >> /home/$1/install.log
subscription-manager register --username ${RHSM_USER} --password ${RHSM_PASSWORD} 
subscription-manager attach --pool=${RHSM_POOL}
if [ $OFFER == "BYOS" ] 
then 
    echo "Attaching Pool ID for RHEL OS" >> /home/$1/install.log
    subscription-manager attach --pool=${12}
fi
subscription-manager repos --enable=jb-eap-7-for-rhel-7-server-rpms 

echo "JBoss EAP RPM installing..." >> /home/$1/install.log
yum-config-manager --disable rhel-7-server-htb-rpms 
yum groupinstall -y jboss-eap7 

echo "Create 2 JBoss EAP nodes on Azure..." >> /home/$1/install.log 
/bin/cp  -rL  $JBOSS_HOME/standalone $JBOSS_HOME/$NODENAME1
/bin/cp  -rL  $JBOSS_HOME/standalone $JBOSS_HOME/$NODENAME2

echo "Eap session replication app deploy..." >> /home/$1/install.log 
yum install -y git
cd /home/$1
git clone https://github.com/Suraj2093/eap-session-replication.git
/bin/cp -rf /home/$1/eap-session-replication/eap-configuration/standalone-ha.xml $JBOSS_HOME/$NODENAME1/configuration/
/bin/cp -rf /home/$1/eap-session-replication/eap-configuration/standalone-ha.xml $JBOSS_HOME/$NODENAME2/configuration/
/bin/cp -rf /home/$1/eap-session-replication/target/eap-session-replication.war $JBOSS_HOME/$NODENAME1/deployments/eap-session-replication.war
/bin/cp -rf /home/$1/eap-session-replication/target/eap-session-replication.war $JBOSS_HOME/$NODENAME2/deployments/eap-session-replication.war
touch $JBOSS_HOME/$NODENAME1/deployments/eap-session-replication.war.dodeploy
touch $JBOSS_HOME/$NODENAME2/deployments/eap-session-replication.war.dodeploy

echo "Configuring JBoss EAP management user..." >> /home/$1/install.log 
$JBOSS_HOME/bin/add-user.sh -sc $JBOSS_HOME/$NODENAME1/configuration -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup' 
$JBOSS_HOME/bin/add-user.sh -sc $JBOSS_HOME/$NODENAME2/configuration -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup' 

echo "Start JBoss EAP 7.2 instances..." >> /home/$1/install.log 
$JBOSS_HOME/bin/standalone.sh -Djboss.node.name=$NODENAME1 -Djboss.server.base.dir=$JBOSS_HOME/$NODENAME1 -c $SVR_CONFIG -b $IP_ADDR -bmanagement $IP_ADDR -bprivate $IP_ADDR -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME > /dev/null 2>&1 &
$JBOSS_HOME/bin/standalone.sh -Djboss.node.name=$NODENAME2 -Djboss.server.base.dir=$JBOSS_HOME/$NODENAME2 -c $SVR_CONFIG -b $IP_ADDR -bmanagement $IP_ADDR -bprivate $IP_ADDR -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djboss.socket.binding.port-offset=$PORT_OFFSET > /dev/null 2>&1 &

echo "Configure firewall for ports 8080, 8180, 9990, 10090..." >> /home/$1/install.log 
firewall-cmd --zone=public --add-port=8080/tcp --permanent 
firewall-cmd --zone=public --add-port=8180/tcp --permanent 
firewall-cmd --zone=public --add-port=9990/tcp --permanent 
firewall-cmd --zone=public --add-port=10090/tcp --permanent 
firewall-cmd --reload 

echo "Open Red Hat software firewall for port 22..." >> /home/$1/install.log
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload

# Seeing a race condition timing error so sleep to delay
sleep 20

echo "Red Hat JBoss EAP 7.2 Intallation End " >> /home/$1/install.log
/bin/date +%H:%M:%S  >> /home/$1/install.log