#!/bin/sh

echo "WILDFLY 18.0.1.Final Standalone Intallation Start..." >> install.progress.txt
/bin/date +%H:%M:%S  >> install.progress.txt

WILDFLY_USER=$1
WILDFLY_PASSWORD=$2
IP_ADDR=$(hostname -I)

echo "WILDFLY_USER: " ${WILDFLY_USER} >> install.progress.txt

echo "WILDFLY Downloading..." >> install.progress.txt
yum install -y git unzip java >> install.out.txt 2>&1
yum -y install wget >> install.out.txt 2>&1
WILDFLY_RELEASE="18.0.1"
wget https://download.jboss.org/wildfly/$WILDFLY_RELEASE.Final/wildfly-$WILDFLY_RELEASE.Final.tar.gz >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Downloading WildFly Failed" >> install.progress.txt; exit $flag;  fi
tar xvf wildfly-$WILDFLY_RELEASE.Final.tar.gz >> install.out.txt 2>&1

echo "Sample app deploy..." >> install.progress.txt
git clone https://github.com/Suraj2093/dukes.git >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Git clone Failed" >> install.progress.txt; exit $flag;  fi
/bin/cp -rf ./dukes/target/JBoss-EAP_on_Azure.war ./wildfly-$WILDFLY_RELEASE.Final/standalone/deployments/ >> install.out.txt 2>&1

echo "Configuring WILDFLY managment user..." >> install.progress.txt
./wildfly-$WILDFLY_RELEASE.Final/bin/add-user.sh -u $WILDFLY_USER -p $WILDFLY_PASSWORD -g 'guest,mgmtgroup' >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "WildFly management user configuration Failed" >> install.progress.txt; exit $flag;  fi

echo "Start WILDFLY 18.0.1.Final instance..." >> install.progress.txt
./wildfly-$WILDFLY_RELEASE.Final/bin/standalone.sh -b $IP_ADDR -bmanagement $IP_ADDR >> install.out.txt 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Starting WildFly service Failed" >> install.progress.txt; exit $flag;  fi

echo "Configure firewall for ports 8080, 9990..." >> install.progress.txt
firewall-cmd --zone=public --add-port=8080/tcp --permanent >> install.out.txt 2>&1
firewall-cmd --zone=public --add-port=9990/tcp --permanent >> install.out.txt 2>&1
firewall-cmd --reload >> install.out.txt 2>&1

echo "Open WILDFLY software firewall for port 22..." >> install.progress.txt
firewall-cmd --zone=public --add-port=22/tcp --permanent >> install.out.txt 2>&1
firewall-cmd --reload >> install.out.txt 2>&1

echo "WILDFLY 18.0.1.Final Standalone Intallation End..." >> install.progress.txt
/bin/date +%H:%M:%S >> install.progress.txt
