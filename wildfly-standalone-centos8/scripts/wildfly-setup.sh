#!/bin/sh

echo "WILDFLY 18.0.1.Final Standalone Intallation Start..." >> wildfly.install.log
/bin/date +%H:%M:%S  >> wildfly.install.log

WILDFLY_USER=$1
WILDFLY_PASSWORD=$2
IP_ADDR=$(hostname -I)

echo "WILDFLY_USER: " ${WILDFLY_USER} >> wildfly.install.log

echo "WILDFLY Downloading..." >> wildfly.install.
echo "yum install -y git unzip java" >> wildfly.install.log
yum install -y git unzip java >> wildfly.install.log 2>&1
echo "yum -y install wget" >> wildfly.install.log
yum -y install wget >> wildfly.install.log 2>&1
WILDFLY_RELEASE="18.0.1"
echo "wget https://download.jboss.org/wildfly/$WILDFLY_RELEASE.Final/wildfly-$WILDFLY_RELEASE.Final.tar.gz" >> wildfly.install.log
wget https://download.jboss.org/wildfly/$WILDFLY_RELEASE.Final/wildfly-$WILDFLY_RELEASE.Final.tar.gz >> wildfly.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Downloading WildFly Failed" >> wildfly.install.log; exit $flag;  fi
echo "tar xvf wildfly-$WILDFLY_RELEASE.Final.tar.gz" >> wildfly.install.log
tar xvf wildfly-$WILDFLY_RELEASE.Final.tar.gz >> wildfly.install.log 2>&1

echo "Sample app deploy..." >> wildfly.install.log
echo "git clone https://github.com/Suraj2093/dukes.git" >> wildfly.install.log
git clone https://github.com/Suraj2093/dukes.git >> wildfly.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Git clone Failed" >> wildfly.install.log; exit $flag;  fi
echo "/bin/cp -rf ./dukes/target/JBoss-EAP_on_Azure.war ./wildfly-$WILDFLY_RELEASE.Final/standalone/deployments/" >> wildfly.install.log
/bin/cp -rf ./dukes/target/JBoss-EAP_on_Azure.war ./wildfly-$WILDFLY_RELEASE.Final/standalone/deployments/ >> wildfly.install.log 2>&1

echo "Configuring WILDFLY managment user..." >> wildfly.install.log
echo "./wildfly-$WILDFLY_RELEASE.Final/bin/add-user.sh -u WILDFLY_USER -p WILDFLY_PASSWORD -g 'guest,mgmtgroup'"  >> wildfly.install.log
./wildfly-$WILDFLY_RELEASE.Final/bin/add-user.sh -u $WILDFLY_USER -p $WILDFLY_PASSWORD -g 'guest,mgmtgroup' >> wildfly.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "WildFly management user configuration Failed" >> wildfly.install.log; exit $flag;  fi

echo "Start WILDFLY 18.0.1.Final instance..." >> wildfly.install.log
echo "./wildfly-$WILDFLY_RELEASE.Final/bin/standalone.sh -b $IP_ADDR -bmanagement $IP_ADDR &" >> wildfly.install.log
./wildfly-$WILDFLY_RELEASE.Final/bin/standalone.sh -b $IP_ADDR -bmanagement $IP_ADDR & >> wildfly.install.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "Starting WildFly service Failed" >> wildfly.install.log; exit $flag;  fi

echo "Configure firewall for ports 8080, 9990..." >> wildfly.install.log
echo "firewall-cmd --zone=public --add-port=8080/tcp --permanent" >> wildfly.install.log
firewall-cmd --zone=public --add-port=8080/tcp --permanent >> wildfly.install.log 2>&1
echo "firewall-cmd --zone=public --add-port=9990/tcp --permanent" >> wildfly.install.log
firewall-cmd --zone=public --add-port=9990/tcp --permanent >> wildfly.install.log 2>&1
echo "firewall-cmd --reload" >> wildfly.install.log
firewall-cmd --reload >> wildfly.install.log 2>&1

echo "Open WILDFLY software firewall for port 22..." >> wildfly.install.log
echo "firewall-cmd --zone=public --add-port=22/tcp --permanent" >> wildfly.install.log
firewall-cmd --zone=public --add-port=22/tcp --permanent >> wildfly.install.log 2>&1
echo "firewall-cmd --reload" >> wildfly.install.log
firewall-cmd --reload >> wildfly.install.log 2>&1

echo "WILDFLY 18.0.1.Final Standalone Intallation End..." >> wildfly.install.log
/bin/date +%H:%M:%S >> wildfly.install.log
