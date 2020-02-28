# VM-Redhat - WildFly 16.0.0.Final standalone mode
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https://raw.githubusercontent.com/SpektraSystems/redhat-mw-cloud-quickstart/master/wildfly-standalone-centos/azuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fwildfly-standalone-centos%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

`Tags: WILDFLY, Red Hat, CentOS`

<!-- TOC -->

1. [Solution Overview and deployed resources](#solution-overview)
2. [Template Solution Architecture ](#template-solution-architecture)
3. [Licenses and Costs ](#licenses-and-costs)
4. [Prerequisites](#prerequisites)
5. [Deployment Steps](#deployment-steps)
6. [Deployment Time](#deployment-time)
7. [Support](#support)

<!-- /TOC -->

## Solution Overview and deployed resources
WildFly 18 is the latest release in a series of JBoss open-source application server offerings. WildFly 18 is an exceptionally fast, lightweight and powerful implementation of the Jakarta Platform specifications. The state-of-the-art architecture built on the Modular Service Container enables services on-demand when your application requires them.

This Azure quickstart template deploys a web applicaton deployed on WildFly 18.0.1.Final running on CentOS 8.This template creates all of the compute resources to run WILDFLY 18.0.1 on top of CentOS 8.0, deploying the following components:
- CentOS 8 VM 
- Public DNS 
- Private Virtual Network 
- Security Configuration 
- WildFly 18.0.1.Final
- Sample application deployed to WildFly 18.0.1.Final

To obtain a rhsm account go to: www.redhat.com and sign in.

To learn more about WildFly 18.0.0.Final, check out:
https://docs.wildfly.org/18/

## Solution overview and deployed resources
This template creates all of the compute resources to run WILDFLY 18.0.1 on top of CentOS 8.0, deploying the following components:
- CentOS 8 VM 
- Public DNS 
- Private Virtual Network 
- Security Configuration 
- WildFly 18.0.1.Final
- Sample application deployed to WildFly 18.0.1.Final

To learn more about WildFly 18.0.0.Final, check out:
https://docs.wildfly.org/18/

## Before you Deploy to Azure

To create the VM, you will need to:

1. Choose an admin user name and password for your VM.  

2. Choose a name for your VM. 

3. Choose a WILDFLY username and password to enable the WILDFLY admin console and deployment method. 

4. Choose a Passphrase to use with your SSH certificate.  This pass phrase will be used as the Team Services SSH endpoint passphrase.

## After you Deploy to Azure

Once you create the VM, open a web broser and got to **http://<PUBLIC_HOSTNAME>:8080/dukes/** and you should see the applicaiton running:

<img src="images/app.png" width="800">

If you want to access the administration console go to **http://<PUBLIC_HOSTNAME>:8080** and click on the link Administration Console:

<img src="images/admin.png" width="800">

## Notes

If you're interested in Red Hat JBoss EAP Azure Quickstart templates, you can fine it as here:

*  <a href="https://github.com/Azure/azure-quickstart-templates/tree/master/jboss-eap-standalone-rhel7" target="_blank"> [Red Hat JBoss EAP on an Azure VM]</a> - Standalone JBoss EAP 7 with a sample web app on a RHEL 7 Azure VM.

*  <a href="https://github.com/Azure/azure-quickstart-templates/tree/master/jboss-eap-standalone-openshift" target="_blank"> [Red Hat JBoss EAP on OpenShift Container Platform on Azure RHEL VM]</a> - All-in-one OpenShift Container Platform 3 cluster and Red Hat JBoss EAP 7 with a sample web app.


