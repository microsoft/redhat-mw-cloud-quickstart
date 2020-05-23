#!/bin/sh

adddate() {
    while IFS= read -r line; do
        printf '%s %s\n' "$(date "+%Y-%m-%d %H:%M:%S")" "$line";
    done
}

/bin/date +%H:%M:%S >> jbosseap.install.log
echo "ooooo      RED HAT JBoss EAP 7.2 RPM INSTALL      ooooo" | adddate >> jbosseap.install.log

export EAP_HOME="/opt/rh/eap7/root/usr/share/wildfly"

JBOSS_EAP_USER=$1
JBOSS_EAP_PASSWORD=$2
RHSM_USER=$3
RHSM_PASSWORD=$4
RHEL_OS_LICENSE_TYPE=$5
RHSM_POOL=$6
IP_ADDR=$(hostname -I)

echo "JBoss EAP admin user : " ${JBOSS_EAP_USER} | adddate >> jbosseap.install.log
echo "Initial JBoss EAP 7.2 setup" | adddate >> jbosseap.install.log
echo "subscription-manager register --username RHSM_USER --password RHSM_PASSWORD" | adddate >> jbosseap.install.log
subscription-manager register --username $RHSM_USER --password $RHSM_PASSWORD >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "ERROR! Red Hat Subscription Manager Registration Failed" | adddate >> jbosseap.install.log; exit $flag;  fi
echo "subscription-manager attach --pool=EAP_POOL" | adddate >> jbosseap.install.log
subscription-manager attach --pool=${RHSM_POOL} >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "ERROR! Pool Attach for JBoss EAP Failed" | adddate >> jbosseap.install.log; exit $flag;  fi
if [ $RHEL_OS_LICENSE_TYPE == "BYOS" ] 
then 
    echo "Attaching Pool ID for RHEL OS" | adddate >> jbosseap.install.log
    echo "subscription-manager attach --pool=RHEL_POOL" | adddate  >> jbosseap.install.log
    subscription-manager attach --pool=$7 >> jbosseap.install.log 2>&1
    flag=$?; if [ $flag != 0 ] ; then echo  "ERROR! Pool Attach for RHEL OS Failed" | adddate >> jbosseap.install.log; exit $flag;  fi
fi
echo "Subscribing the system to get access to JBoss EAP 7.2 repos" | adddate >> jbosseap.install.log

# Install JBoss EAP 7.2
echo "subscription-manager repos --enable=jb-eap-7.2-for-rhel-8-x86_64-rpms" | adddate >> jbosseap.install.log
subscription-manager repos --enable=jb-eap-7.2-for-rhel-8-x86_64-rpms >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "ERROR! Enabling repos for JBoss EAP Failed" | adddate >> jbosseap.install.log; exit $flag;  fi

echo "Installing JBoss EAP 7.2 repos" | adddate >> jbosseap.install.log
echo "yum groupinstall -y jboss-eap7" | adddate >> jbosseap.install.log
yum groupinstall -y jboss-eap7 >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "ERROR! JBoss EAP installation Failed" | adddate >> jbosseap.install.log; exit $flag;  fi

echo "Start JBoss-EAP service" | adddate >> jbosseap.install.log
echo "$EAP_HOME/bin/standalone.sh -c standalone-full.xml -b $IP_ADDR -bmanagement $IP_ADDR &" | adddate >> jbosseap.install.log
$EAP_HOME/bin/standalone.sh -c standalone-full.xml -b $IP_ADDR -bmanagement $IP_ADDR & >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "ERROR! Starting JBoss EAP service Failed" | adddate >> jbosseap.install.log; exit $flag;  fi

echo "Installing GIT" | adddate >> jbosseap.install.log
echo "yum install -y git" | adddate >> jbosseap.install.log
yum install -y git | adddate >> jbosseap.install.log 2>&1

echo "Getting the sample JBoss-EAP on Azure app to install" | adddate >> jbosseap.install.log
echo "git clone https://github.com/Suraj2093/dukes.git" | adddate >> jbosseap.install.log
git clone https://github.com/Suraj2093/dukes.git >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "ERROR! Git clone Failed" | adddate >> jbosseap.install.log; exit $flag;  fi
echo "mv ./dukes/target/JBoss-EAP_on_Azure.war $EAP_HOME/standalone/deployments/JBoss-EAP_on_Azure.war" | adddate >> jbosseap.install.log
mv ./dukes/target/JBoss-EAP_on_Azure.war $EAP_HOME/standalone/deployments/JBoss-EAP_on_Azure.war | adddate >> jbosseap.install.log 2>&1
echo "cat > $EAP_HOME/standalone/deployments/JBoss-EAP_on_Azure.war.dodeploy" | adddate >> jbosseap.install.log
cat > $EAP_HOME/standalone/deployments/JBoss-EAP_on_Azure.war.dodeploy | adddate >> jbosseap.install.log 2>&1

echo "Configuring JBoss EAP management user" | adddate >> jbosseap.install.log
echo "$EAP_HOME/bin/add-user.sh -u JBOSS_EAP_USER -p JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup'" | adddate >> jbosseap.install.log
$EAP_HOME/bin/add-user.sh -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup' >> jbosseap.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "ERROR! JBoss EAP management user configuration Failed" | adddate >> jbosseap.install.log; exit $flag;  fi

# Open Red Hat software firewall for port 8080 and 9990:
echo "firewall-cmd --zone=public --add-port=8080/tcp --permanent" | adddate >> jbosseap.install.log
firewall-cmd --zone=public --add-port=8080/tcp --permanent | adddate >> jbosseap.install.log 2>&1
echo "firewall-cmd --zone=public --add-port=9990/tcp --permanent" | adddate >> jbosseap.install.log
firewall-cmd --zone=public --add-port=9990/tcp --permanent | adddate  >> jbosseap.install.log 2>&1
echo "firewall-cmd --reload" | adddate >> jbosseap.install.log
firewall-cmd --reload | adddate >> jbosseap.install.log 2>&1

# Open Red Hat software firewall for port 22:
echo "firewall-cmd --zone=public --add-port=22/tcp --permanent" | adddate >> jbosseap.install.log
firewall-cmd --zone=public --add-port=22/tcp --permanent | adddate >> jbosseap.install.log 2>&1
echo "firewall-cmd --reload" | adddate >> jbosseap.install.log
firewall-cmd --reload | adddate >> jbosseap.install.log 2>&1

# Seeing a race condition timing error so sleep to delay
sleep 20

echo "ALL DONE!" | adddate >> jbosseap.install.log
/bin/date +%H:%M:%S >> jbosseap.install.log