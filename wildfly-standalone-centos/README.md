# VM-Redhat - WildFly 16.0.0.Final standalone mode
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fwildfly-standalone-centos%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fwildfly-standalone-centos%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

`Tags: WILDFLY, Red Hat, CentOS`

<!-- TOC -->

1. [Solution Overview ](#solution-overview)
2. [Template Solution Architecture ](#template-solution-architecture)
3. [Licenses and Costs ](#licenses-and-costs)
4. [Prerequisites](#prerequisites)
5. [Deployment Steps](#deployment-steps)
6. [Deployment Time](#deployment-time)
7. [Post Deployment Steps](#post-deployment-steps)
8. [Support](#support)

<!-- /TOC -->

## Solution Overview
WildFly 18 is the latest release in a series of JBoss open-source application server offerings. WildFly 18 is an exceptionally fast, lightweight and powerful implementation of the Jakarta Platform specifications. The state-of-the-art architecture built on the Modular Service Container enables services on-demand when your application requires them.

This Azure quickstart template deploys a web applicaton deployed on WildFly 18.0.1.Final running on CentOS 8.

To obtain a rhsm account go to: www.redhat.com and sign in.

## Template Solution Architecture 

This template creates all of the compute resources to run WILDFLY 18.0.1 on top of CentOS 8.0, deploying the following components:

- CentOS 8 VM 
- Public DNS 
- Private Virtual Network 
- Security Configuration 
- WildFly 18.0.1.Final
- Sample application deployed to WildFly 18.0.1.Final

Following is the Architecture :
<img src="images/wildfly.arch.PNG" width="800">

To learn more about WildFly 18.0.0.Final, check out:
https://docs.wildfly.org/18/

## Licenses and Costs 

This uses CentOS 8 image which is a PAY AS YOU GO image and doesn't require the user to license it, it will be licensed automatically after the instance is launched first time and user will be charged hourly in addition to Microsoft's Linux VM rates.  Click [here](https://azure.microsoft.com/en-gb/pricing/details/virtual-machines/linux/#red-hat) for pricing details.

## Prerequisites 

1. Azure Subscription with specified payment method (CentOS-Based 8.0 is a market place product and requires payment method to be specified in Azure Subscription)

2. To create the VM, you will need to:

    - Choose an admin user name and password for your VM.  

    - Choose a name for your VM. 

    - Choose a WILDFLY username and password to enable the WILDFLY admin console and deployment method. 

    - Choose a Passphrase to use with your SSH certificate.  This pass phrase will be used as the Team Services SSH endpoint passphrase.

## Deployment Steps  

Build your environment with WILDFLY 18.0.1 on top of CentOS 8.0 on Azure in a few simple steps:  
1. Launch the Template by click on Deploy to Azure button.  
2. Fill in the following parameter values. Then accept the terms and condition before clicking on Purchase.

    - **Subscription** - Choose the right subscription where you would like to deploy.

    - **Resource Group** - Create a new Resource group or you can select an existing one.

    - **Location** - Choose the right location for your deployment.

    - **Admin Username** - User account name for logging into your CentOS VM.

    - **Admin Password** - User account password for logging into your CentOS VM.

    - **DNS Label Prefix** - DNS Label for the Public IP. Must be lowercase. It should match with the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$ or it will raise an error.

    - **Wildfly Username** - User name for Wildfly Manager.

    - **Wildfly Password** - User account password for Wildfly Manager.

    - **SSH Key Data** - Generate an SSH key using Puttygen and provide the data here.

    - Leave the rest of the Parameter Value as it is and proceed.

## Deployment Time 

The deployment takes less than 10 minutes to complete.

## Post Deployment Steps

- Once the deployment is successfull, go the VM and copy the Public IP of the VM.
- Open a web browser and go to **http://<PUBLIC_HOSTNAME>:8080/dukes/** and you should see the applicaiton running:

<img src="images/app.png" width="800">

- If you want to access the administration console go to **http://<PUBLIC_HOSTNAME>:8080** and click on the link Administration Console:

<img src="images/admin.png" width="800">

## Notes

If you're interested in Red Hat JBoss EAP Azure Quickstart templates, you can fine it as here:

*  <a href="https://github.com/Azure/azure-quickstart-templates/tree/master/jboss-eap-standalone-rhel7" target="_blank"> [Red Hat JBoss EAP on an Azure VM]</a> - Standalone JBoss EAP 7 with a sample web app on a RHEL 7 Azure VM.

*  <a href="https://github.com/Azure/azure-quickstart-templates/tree/master/jboss-eap-standalone-openshift" target="_blank"> [Red Hat JBoss EAP on OpenShift Container Platform on Azure RHEL VM]</a> - All-in-one OpenShift Container Platform 3 cluster and Red Hat JBoss EAP 7 with a sample web app.

## Support 

For any support related questions, issues or customization requirements, please contact info@spektrasystems.com

**** test change for restart build**
