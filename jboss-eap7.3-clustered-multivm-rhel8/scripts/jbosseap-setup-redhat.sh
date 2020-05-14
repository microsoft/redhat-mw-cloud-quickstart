#!/bin/sh

echo "Red Hat JBoss EAP 7.3 Cluster Intallation Start " >> install.progress.txt
/bin/date +%H:%M:%S  >> install.progress.txt

export EAP_HOME="/opt/rh/eap7/root/usr/share"
JBOSS_EAP_USER=$1
JBOSS_EAP_PASSWORD=$2
RHEL_OS_LICENSE_TYPE=$3
RHSM_USER=$4
RHSM_PASSWORD=$5
RHSM_POOL=$6
IP_ADDR=$7
STORAGE_ACCOUNT_NAME=$8
CONTAINER_NAME=$9
STORAGE_ACCESS_KEY=$(echo "${10}" | openssl enc -d -base64)

echo "JBoss EAP admin user"+${JBOSS_EAP_USER} >> install.progress.txt
echo "Private IP Address of VM"+${IP_ADDR} >> install.progress.txt
echo "Storage Account Name"+${STORAGE_ACCOUNT_NAME} >> install.progress.txt
echo "Storage Container Name"+${CONTAINER_NAME} >> install.progress.txt
echo "Storage Account Access Key"+${STORAGE_ACCESS_KEY} >> install.progress.txt
echo "RHSM_USER: " ${RHSM_USER} >> install.progress.txt
echo "RHSM_POOL: " ${RHSM_POOL} >> install.progress.txt

echo "Configure firewall for ports 8080, 8180, 9990, 10090..." >> install.progress.txt

sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent >> install.out.txt 2>&1
sudo firewall-cmd --zone=public --add-port=9990/tcp --permanent >> install.out.txt 2>&1
sudo firewall-cmd --zone=public --add-port=45700/tcp --permanent >> install.out.txt 2>&1
sudo firewall-cmd --zone=public --add-port=7600/tcp --permanent >> install.out.txt 2>&1
sudo firewall-cmd --zone=public --add-port=55200/tcp --permanent >> install.out.txt 2>&1
sudo firewall-cmd --zone=public --add-port=45688/tcp --permanent >> install.out.txt 2>&1
sudo firewall-cmd --reload >> install.out.txt 2>&1
sudo iptables-save >> install.out.txt 2>&1

echo "Initial JBoss EAP 7.3 setup" >> install.progress.txt
subscription-manager register --username $RHSM_USER --password $RHSM_PASSWORD >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Registration Failed" >> install.progress.txt; exit $flag;  fi
subscription-manager attach --pool=${RHSM_POOL} >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Pool Attach for JBoss EAP Failed" >> install.progress.txt; exit $flag;  fi
if [ $RHEL_OS_LICENSE_TYPE == "BYOS" ]
then
    echo "Attaching Pool ID for RHEL OS" >> install.progress.txt
    subscription-manager attach --pool=${11} >> install.out.txt 2>&1
    flag=$?; if [ $flag != 0 ] ; then echo  "Pool Attach for RHEL OS Failed" >> install.progress.txt; exit $flag;  fi
fi
echo "Subscribing the system to get access to JBoss EAP 7.3 repos" >> install.progress.txt

echo "Install openjdk, wget, git, unzip, vim"  >> install.progress.txt
sudo yum install java-1.8.0-openjdk wget unzip vim git -y >> install.out.txt 2>&1

# Install JBoss EAP 7.3	
subscription-manager repos --enable=jb-eap-7.3-for-rhel-8-x86_64-rpms >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Enabling repos for JBoss EAP Failed" >> install.progress.txt; exit $flag;  fi

echo "Installing JBoss EAP 7.3 repos" >> install.progress.txt
yum groupinstall -y jboss-eap7 >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "JBoss EAP installation Failed" >> install.progress.txt; exit $flag;  fi

echo "Copy the standalone-azure-ha.xml from EAP_HOME/doc/wildfly/examples/configs folder to EAP_HOME/wildfly/standalone/configuration folder" >> install.progress.txt
cp $EAP_HOME/doc/wildfly/examples/configs/standalone-azure-ha.xml $EAP_HOME/wildfly/standalone/configuration/ >> install.out.txt 2>&1

echo "change the jgroups stack from UDP to TCP " >> install.progress.txt
sed -i 's/stack="udp"/stack="tcp"/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml >> install.out.txt 2>&1

echo "Update interfaces section update jboss.bind.address.management, jboss.bind.address and jboss.bind.address.private from 127.0.0.1 to 0.0.0.0" >> install.progress.txt
sed -i 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml >> install.out.txt 2>&1
sed -i 's/jboss.bind.address:127.0.0.1/jboss.bind.address:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml >> install.out.txt 2>&1
sed -i 's/jboss.bind.address.private:127.0.0.1/jboss.bind.address.private:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml >> install.out.txt 2>&1

echo "Start JBoss server" >> install.progress.txt
$EAP_HOME/wildfly/bin/standalone.sh -bprivate $IP_ADDR -b $IP_ADDR -bmanagement $IP_ADDR --server-config=standalone-azure-ha.xml -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djava.net.preferIPv4Stack=true & >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Starting JBoss EAP service Failed" >> install.progress.txt; exit $flag;  fi

echo "export EAP_HOME="/opt/rh/eap7/root/usr/share"" >> /bin/jbossservice.sh
echo "$EAP_HOME/wildfly/bin/standalone.sh -bprivate $IP_ADDR -b $IP_ADDR -bmanagement $IP_ADDR --server-config=standalone-azure-ha.xml -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djava.net.preferIPv4Stack=true &" >> /bin/jbossservice.sh
chmod +x /bin/jbossservice.sh

yum install cronie cronie-anacron >> install.out.txt 2>&1
service crond start >> install.out.txt 2>&1
chkconfig crond on >> install.out.txt 2>&1
echo "@reboot sleep 90 && /bin/jbossservice.sh" >>  /var/spool/cron/root
chmod 600 /var/spool/cron/root

echo "Deploy an application " >> install.progress.txt
git clone https://github.com/Suraj2093/eap-session-replication.git >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Git clone Failed" >> install.progress.txt; exit $flag; fi
cp eap-session-replication/target/eap-session-replication.war $EAP_HOME/wildfly/standalone/deployments/ >> install.out.txt 2>&1
touch $EAP_HOME/wildfly/standalone/deployments/eap-session-replication.war.dodeploy >> install.out.txt 2>&1

echo "Configuring JBoss EAP management user..." >> install.progress.txt 
$EAP_HOME/wildfly/bin/add-user.sh  -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup' >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "JBoss EAP management user configuration Failed" >> install.progress.txt; exit $flag;  fi

# Seeing a race condition timing error so sleep to delay
sleep 20

echo "Red Hat JBoss EAP 7.3 Cluster Intallation End " >> install.progress.txt
/bin/date +%H:%M:%S  >> install.progress.txt