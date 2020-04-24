#!/bin/sh

# $1 - VM Host User Name

/bin/date +%H:%M:%S >> /home/$1/install.progress.txt
echo "ooooo      RED HAT JBoss EAP 7.2 RPM INSTALL      ooooo" >> /home/$1/install.progress.txt

export EAP_HOME="/opt/rh/eap7/root/usr/share/wildfly"

JBOSS_EAP_USER=$2
JBOSS_EAP_PASSWORD=$3
RHSM_USER=$4
RHSM_PASSWORD=$5
RHEL_OS_LICENSE_TYPE=$6
RHSM_POOL=$7
IP_ADDR=$(hostname -I)

echo "JBoss EAP admin user"+${JBOSS_EAP_USER} >> /home/$1/install.progress.txt
echo "Initial JBoss EAP 7.2 setup" >> /home/$1/install.progress.txt
subscription-manager register --username $RHSM_USER --password $RHSM_PASSWORD  >> /home/$1/install.progress.txt 2>&1
subscription-manager attach --pool=${RHSM_POOL} >> /home/$1/install.progress.txt 2>&1
if [ $RHEL_OS_LICENSE_TYPE == "BYOS" ]
then
    echo "Attaching Pool ID for RHEL OS" >> /home/$1/install.progress.txt
    subscription-manager attach --pool=$8 >> /home/$1/install.progress.txt 2>&1
fi
echo "Subscribing the system to get access to JBoss EAP 7.2 repos" >> /home/$1/install.progress.txt

# Install JBoss EAP 7.2 
subscription-manager repos --enable=jb-eap-7.2-for-rhel-8-x86_64-rpms >> /home/$1/install.out.txt 2>&1

echo "Installing JBoss EAP 7.2 repos" >> /home/$1/install.progress.txt
yum groupinstall -y jboss-eap7 >> /home/$1/install.out.txt 2>&1

$EAP_HOME/bin/standalone.sh -c standalone-full.xml -b $IP_ADDR -bmanagement $IP_ADDR &

echo "Installing GIT" >> /home/$1/install.progress.txt
yum install -y git >> /home/$1/install.out.txt 2>&1

cd /home/$1
echo "Getting the sample JBoss-EAP on Azure app to install" >> /home/$1/install.progress.txt
git clone https://github.com/Suraj2093/dukes.git >> /home/$1/install.out.txt 2>&1
mv /home/$1/dukes/target/JBoss-EAP_on_Azure.war $EAP_HOME/standalone/deployments/JBoss-EAP_on_Azure.war
cat > $EAP_HOME/standalone/deployments/JBoss-EAP_on_Azure.war.dodeploy

echo "Configuring JBoss EAP management user" >> /home/$1/install.progress.txt
$EAP_HOME/bin/add-user.sh -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup'

# Open Red Hat software firewall for port 8080 and 9990:
firewall-cmd --zone=public --add-port=8080/tcp --permanent  >> /home/$1/install.out.txt 2>&1
firewall-cmd --zone=public --add-port=9990/tcp --permanent  >> /home/$1/install.out.txt 2>&1
firewall-cmd --reload  >> /home/$1/install.out.txt 2>&1
    
echo "Done." >> /home/$1/install.progress.txt
/bin/date +%H:%M:%S >> /home/$1/install.progress.txt

# Open Red Hat software firewall for port 22:
firewall-cmd --zone=public --add-port=22/tcp --permanent >> /home/$1/install.out.txt 2>&1
firewall-cmd --reload >> /home/$1/install.out.txt 2>&1

# Seeing a race condition timing error so sleep to delay
sleep 20

echo "ALL DONE!" >> /home/$1/install.progress.txt
/bin/date +%H:%M:%S >> /home/$1/install.progress.txt
