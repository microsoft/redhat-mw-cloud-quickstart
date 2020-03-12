#!/bin/sh

# $1 - VM Host User Name

echo "Red Hat JBoss EAP 7 Cluster Intallation Start: " | /bin/date +%H:%M:%S  >> /home/$1/install.log

export JBOSS_HOME="/opt/rh/jboss-eap-7.2/"
export EAP_USER=$2
export EAP_PASSWORD=$3
export IP_ADDR=$4
export STORAGE_ACCOUNT_NAME=${5}
export CONTAINER_NAME=$6
export STORAGE_ACCESS_KEY=$(echo "${7}" | openssl enc -d -base64)

echo "EAP admin user"+${EAP_USER} >> /home/$1/install.log
echo "Private IP Address of VM"+${IP_ADDR} >> /home/$1/install.log
echo "Storage Account Name"+${STORAGE_ACCOUNT_NAME} >> /home/$1/install.log
echo "Storage Container Name"+${CONTAINER_NAME} >> /home/$1/install.log
echo "Storage Account Access Key"+${STORAGE_ACCESS_KEY} >> /home/$1/install.log

echo "Configure firewall for ports 8080, 8180, 9990, 10090..." >> /home/$1/install.log 

sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9990/tcp --permanent
sudo firewall-cmd --zone=public --add-port=45700/tcp --permanent
sudo firewall-cmd --zone=public --add-port=7600/tcp --permanent
sudo firewall-cmd --zone=public --add-port=55200/tcp --permanent
sudo firewall-cmd --zone=public --add-port=45688/tcp --permanent
sudo firewall-cmd --reload
sudo iptables-save

echo "Install openjdk, wget, git, unzip, vim"  >> /home/$1/install.log 
sudo yum install java-1.8.0-openjdk wget unzip vim git -y

echo "Downlaod jboss-eap-7.2"  >> /home/$1/install.log 
wget https://vmuagstore.blob.core.windows.net/software/jboss-eap-7.2.0.zip

echo "unzip jboss-eap"  >> /home/$1/install.log 

sudo unzip jboss-eap-7.2.0.zip -d /opt/rh/


echo "Copy the standalone-azure-ha.xml from JBOSS_HOME/docs/examples/configs folder tp JBOSS_HOME/standalone/configuration folder" >> /home/$1/install.log
cp $JBOSS_HOME/docs/examples/configs/standalone-azure-ha.xml $JBOSS_HOME/standalone/configuration/

echo "change the jgroups stack from UDP to TCP " >> /home/$1/install.log

sed -i 's/stack="udp"/stack="tcp"/g'  $JBOSS_HOME/standalone/configuration/standalone-azure-ha.xml

echo "Update interfaces section update jboss.bind.address.management, jboss.bind.address and jboss.bind.address.private from 127.0.0.1 to 0.0.0.0" >> /home/$1/install.log
sed -i 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/g'  $JBOSS_HOME/standalone/configuration/standalone-azure-ha.xml
sed -i 's/jboss.bind.address:127.0.0.1/jboss.bind.address:0.0.0.0/g'  $JBOSS_HOME/standalone/configuration/standalone-azure-ha.xml
sed -i 's/jboss.bind.address.private:127.0.0.1/jboss.bind.address.private:0.0.0.0/g'  $JBOSS_HOME/standalone/configuration/standalone-azure-ha.xml

echo "start jboss server" >> /home/$1/install.log

$JBOSS_HOME/bin/standalone.sh -bprivate $IP_ADDR --server-config=standalone-azure-ha.xml -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djava.net.preferIPv4Stack=true &

echo "deploy an applicaiton " >> /home/$1/install.log
git clone https://github.com/danieloh30/eap-session-replication.git
cp eap-session-replication/target/eap-session-replication.war $JBOSS_HOME/standalone/deployments/
touch $JBOSS_HOME/standalone/deployments/eap-session-replication.war.dodeploy

echo "Configuring EAP managment user..." >> /home/$1/install.log 
$JBOSS_HOME/bin/add-user.sh  -u $EAP_USER -p $EAP_PASSWORD -g 'guest,mgmtgroup'


echo "Configure SELinux to use Linux ACL's for file protection..." >> /home/$1/install.log
setsebool -P allow_ftpd_full_access 1

# Seeing a race condition timing error so sleep to deplay
sleep 20
chown $1.jboss /home/$1/install.log

echo "Red Hat JBoss EAP 7 Cluster Intallation End: " | /bin/date +%H:%M:%S  >> /home/$1/install.log
