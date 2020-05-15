#!/bin/sh

echo "Red Hat JBoss EAP 7.2 Cluster Intallation Start " >> jbosseap.install.log
/bin/date +%H:%M:%S  >> jbosseap.install.log

export EAP_HOME="/opt/rh/eap7/root/usr/share"
JBOSS_EAP_USER=$1
JBOSS_EAP_PASSWORD=$2
RHEL_OS_LICENSE_TYPE=$3
RHSM_USER=$4
RHSM_PASSWORD=$5
RHSM_POOL=$6
IP_ADDR=$(hostname -I)
STORAGE_ACCOUNT_NAME=${7}
CONTAINER_NAME=$8
STORAGE_ACCESS_KEY=$(echo "${9}" | openssl enc -d -base64)

echo "JBoss EAP admin user: " ${JBOSS_EAP_USER} >> jbosseap.install.log
echo "Storage Account Name: " ${STORAGE_ACCOUNT_NAME} >> jbosseap.install.log
echo "Storage Container Name: " ${CONTAINER_NAME} >> jbosseap.install.log
echo "RHSM_USER: " ${RHSM_USER} >> jbosseap.install.log

echo "Configure firewall for ports 8080, 8180, 9990, 10090..." >> jbosseap.install.log

echo "firewall-cmd --zone=public --add-port=8080/tcp --permanent" >> jbosseap.install.log
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent >> jbosseap.install.log 2>&1
echo "firewall-cmd --zone=public --add-port=9990/tcp --permanent" >> jbosseap.install.log
sudo firewall-cmd --zone=public --add-port=9990/tcp --permanent >> jbosseap.install.log 2>&1
echo "firewall-cmd --zone=public --add-port=45700/tcp --permanent" >> jbosseap.install.log
sudo firewall-cmd --zone=public --add-port=45700/tcp --permanent >> jbosseap.install.log 2>&1
echo "firewall-cmd --zone=public --add-port=7600/tcp --permanent" >> jbosseap.install.log
sudo firewall-cmd --zone=public --add-port=7600/tcp --permanent >> jbosseap.install.log 2>&1
echo "firewall-cmd --zone=public --add-port=55200/tcp --permanent" >> jbosseap.install.log
sudo firewall-cmd --zone=public --add-port=55200/tcp --permanent >> jbosseap.install.log 2>&1
echo "firewall-cmd --zone=public --add-port=45688/tcp --permanent" >> jbosseap.install.log
sudo firewall-cmd --zone=public --add-port=45688/tcp --permanent >> jbosseap.install.log 2>&1
echo "firewall-cmd --reload" >> jbosseap.install.log
sudo firewall-cmd --reload >> jbosseap.install.log 2>&1
echo "iptables-save" >> jbosseap.install.log
sudo iptables-save >> jbosseap.install.log 2>&1

echo "Initial JBoss EAP 7.2 setup" >> jbosseap.install.log
echo "subscription-manager register --username RHSM_USER --password RHSM_PASSWORD" >> jbosseap.install.log
subscription-manager register --username $RHSM_USER --password $RHSM_PASSWORD >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Red Hat Manager Registration Failed" >> jbosseap.install.log; exit $flag;  fi
echo "subscription-manager attach --pool=EAP_POOL" >> jbosseap.install.log
subscription-manager attach --pool=${RHSM_POOL} >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Pool Attach for JBoss EAP Failed" >> jbosseap.install.log; exit $flag;  fi
if [ $RHEL_OS_LICENSE_TYPE == "BYOS" ]
then
    echo "Attaching Pool ID for RHEL OS" >> jbosseap.install.log
    echo "subscription-manager attach --pool=RHEL_POOL"  >> jbosseap.install.log
    subscription-manager attach --pool=${10} >> jbosseap.install.log 2>&1
    flag=$?; if [ $flag != 0 ] ; then echo  "Pool Attach for RHEL OS Failed" >> jbosseap.install.log; exit $flag;  fi
fi
echo "Subscribing the system to get access to JBoss EAP 7.2 repos" >> jbosseap.install.log

echo "Install openjdk, wget, git, unzip, vim"  >> jbosseap.install.log
echo "sudo yum install java-1.8.0-openjdk wget unzip vim git -y"  >> jbosseap.install.log
sudo yum install java-1.8.0-openjdk wget unzip vim git -y >> jbosseap.install.log 2>&1

# Install JBoss EAP 7.2
echo "subscription-manager repos --enable=jb-eap-7-for-rhel-7-server-rpms" >> jbosseap.install.log
subscription-manager repos --enable=jb-eap-7-for-rhel-7-server-rpms >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Enabling repos for JBoss EAP Failed" >> jbosseap.install.log; exit $flag;  fi
echo "yum-config-manager --disable rhel-7-server-htb-rpms" >> jbosseap.install.log
yum-config-manager --disable rhel-7-server-htb-rpms >> jbosseap.install.log

echo "Installing JBoss EAP 7.2 repos" >> jbosseap.install.log
echo "yum groupinstall -y jboss-eap7" >> jbosseap.install.log
yum groupinstall -y jboss-eap7 >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "JBoss EAP installation Failed" >> jbosseap.install.log; exit $flag;  fi

echo "Copy the standalone-azure-ha.xml from EAP_HOME/doc/wildfly/examples/configs folder to EAP_HOME/wildfly/standalone/configuration folder" >> jbosseap.install.log
echo "cp $EAP_HOME/doc/wildfly/examples/configs/standalone-azure-ha.xml $EAP_HOME/wildfly/standalone/configuration/" >> jbosseap.install.log
cp $EAP_HOME/doc/wildfly/examples/configs/standalone-azure-ha.xml $EAP_HOME/wildfly/standalone/configuration/ >> jbosseap.install.log 2>&1

echo "change the jgroups stack from UDP to TCP " >> jbosseap.install.log
echo "sed -i 's/stack="udp"/stack="tcp"/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml" >> jbosseap.install.log
sed -i 's/stack="udp"/stack="tcp"/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml >> jbosseap.install.log 2>&1

echo "Update interfaces section update jboss.bind.address.management, jboss.bind.address and jboss.bind.address.private from 127.0.0.1 to 0.0.0.0" >> jbosseap.install.log
echo "sed -i 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml" >> jbosseap.install.log
sed -i 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml >> jbosseap.install.log 2>&1
echo "sed -i 's/jboss.bind.address:127.0.0.1/jboss.bind.address:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml" >> jbosseap.install.log
sed -i 's/jboss.bind.address:127.0.0.1/jboss.bind.address:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml >> jbosseap.install.log 2>&1
echo "sed -i 's/jboss.bind.address.private:127.0.0.1/jboss.bind.address.private:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml" >> jbosseap.install.log
sed -i 's/jboss.bind.address.private:127.0.0.1/jboss.bind.address.private:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml >> jbosseap.install.log 2>&1

echo "Start JBoss server" >> jbosseap.install.log
echo "$EAP_HOME/wildfly/bin/standalone.sh -bprivate $IP_ADDR -b $IP_ADDR -bmanagement $IP_ADDR --server-config=standalone-azure-ha.xml -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djava.net.preferIPv4Stack=true &" >> jbosseap.install.log
$EAP_HOME/wildfly/bin/standalone.sh -bprivate $IP_ADDR -b $IP_ADDR -bmanagement $IP_ADDR --server-config=standalone-azure-ha.xml -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djava.net.preferIPv4Stack=true & >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Starting JBoss EAP service Failed" >> jbosseap.install.log; exit $flag;  fi

echo "export EAP_HOME="/opt/rh/eap7/root/usr/share"" >> /bin/jbossservice.sh
echo "$EAP_HOME/wildfly/bin/standalone.sh -bprivate $IP_ADDR -b $IP_ADDR -bmanagement $IP_ADDR --server-config=standalone-azure-ha.xml -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djava.net.preferIPv4Stack=true &" >> /bin/jbossservice.sh
chmod +x /bin/jbossservice.sh

yum install cronie cronie-anacron >> jbosseap.install.log 2>&1
service crond start >> jbosseap.install.log 2>&1
chkconfig crond on >> jbosseap.install.log 2>&1
echo "@reboot sleep 90 && /bin/jbossservice.sh" >>  /var/spool/cron/root
chmod 600 /var/spool/cron/root

echo "Deploy an application " >> jbosseap.install.log
echo "git clone https://github.com/Suraj2093/eap-session-replication.git" >> jbosseap.install.log
git clone https://github.com/Suraj2093/eap-session-replication.git >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Git clone Failed" >> jbosseap.install.log; exit $flag; fi
echo "cp eap-session-replication/target/eap-session-replication.war $EAP_HOME/wildfly/standalone/deployments/" >> jbosseap.install.log
cp eap-session-replication/target/eap-session-replication.war $EAP_HOME/wildfly/standalone/deployments/ >> jbosseap.install.log 2>&1
echo "touch $EAP_HOME/wildfly/standalone/deployments/eap-session-replication.war.dodeploy" >> jbosseap.install.log
touch $EAP_HOME/wildfly/standalone/deployments/eap-session-replication.war.dodeploy >> jbosseap.install.log 2>&1

echo "Configuring JBoss EAP management user..." >> jbosseap.install.log
echo "$EAP_HOME/bin/add-user.sh -u JBOSS_EAP_USER -p JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup'" >> jbosseap.install.log
$EAP_HOME/wildfly/bin/add-user.sh  -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup' >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "JBoss EAP management user configuration Failed" >> jbosseap.install.log; exit $flag;  fi

# Seeing a race condition timing error so sleep to delay
sleep 20

echo "Red Hat JBoss EAP 7.2 Cluster Intallation End " >> jbosseap.install.log
/bin/date +%H:%M:%S  >> jbosseap.install.log