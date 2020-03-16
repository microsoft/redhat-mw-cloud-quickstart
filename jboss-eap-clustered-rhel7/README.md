# VM-Redhat - JBoss EAP 7 cluster mode
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-standalone-rhel8%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-clustered-rhel7%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

`Tags: JBoss, EAP, Red Hat,EAP7, CLUSTER`

<!-- TOC -->

1. [Solution Overview ](#solution-overview)
2. [Template Solution Architecture ](#template-solution-architecture)
3. [Licenses and Costs ](#licenses-and-costs)
4. [Prerequisites](#prerequisites)
5. [Deployment Steps](#deployment-steps)
6. [Deployment Time](#deployment-time)
7. [Post Deployment Steps](#post-deployment-steps)

<!-- /TOC -->

## Solution Overview

JBoss EAP is an open source platform for highly transactional, web-scale Java applications. EAP combines the familiar and popular Jakarta EE specifications with the latest technologies, like Microprofile, to modernize your applications from traditional Java EE into the new world of DevOps, cloud, containers, and microservices. EAP includes everything needed to build, run, deploy, and manage enterprise Java applications in a variety of environments, including on-premise, virtual environments, and in private, public, and hybrid clouds.

This template deploys a web applicaton deployed on JBoss EAP 7.2 cluster running on RHEL 8.

To obtain a rhsm account go to: www.redhat.com and sign in.

## Template Solution Architecture
This template creates all of the compute resources to run JBoss EAP 7 on top of RHEL 7.2, deploying the following components:

- RHEL 8.0 VM 
- Public DNS 
- Private Virtual Network 
- Security Configuration 
- JBoss EAP 7
- Sample application deployed to JBoss EAP 7

Following is the Architecture :

<img src="images/eap-rhel-arch.png" width="800">

To learn more about JBoss Enterprise Application Platform, check out:
https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/


## Licenses and Costs

This uses RHEL 8.0 image which is a PAY AS YOU GO image and doesn't require the user to license it, it will be licensed automatically after the instance is launched first time and user will be charged hourly in addition to Microsoft's Linux VM rates.  Click [here](https://azure.microsoft.com/en-gb/pricing/details/virtual-machines/linux/#red-hat) for pricing details. You also need to have a RedHat account to register to Red Hat Subscription Manager (RHSM). Click [here](https://access.redhat.com/products/red-hat-subscription-management) to know more about RHSM and pricing.

## Solution overview and deployed resources
This template creates all of the compute resources to run JBoss EAP 7 on top of RHEL 7.2, deploying the following components:
- RHEL 7.2 VM 
- Public DNS 
- Private Virtual Network 
- Security Configuration 
- JBoss EAP 7
- Sample application deployed to JBoss EAP 7

To learn more about JBoss Enterprise Application Platform, check out:
https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/

## Prerequisites

1. Azure Subscription with specified payment method (RHEL 8 is a market place product and requires payment method to be specified in Azure Subscription)

2. To deploy the template, you will need to:

   - Choose an admin user name and password for your VM.
    
   - Choose a name for your VM.

   - Choose a EAP user name and password to enable the EAP manager UI and deployment method.
    
   - Provide your RHSM Username and Password
    
   - Choose a Pass phrase to use with your SSH certificate.  This pass phrase will be used as the Team Services SSH endpoint passphrase.

## Deployment Steps

Build your environment with EAP 7.2 on top of RHEL 8.0 on Azure in a few simple steps:

   - **Subscription** - Choose the right subscription where you would like to deploy.

   - **Resource Group** - Create a new Resource group or you can select an existing one.

   - **Location** - Choose the right location for your deployment.

   - **Admin Username** - User account name for logging into your RHEL VM.

   - **Admin Password** - User account password for logging into your RHEL VM.
   
   - **DNS Label Prefix** - DNS Label for the Public IP. Must be lowercase. It should match with the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$ or it will raise an error.

   - **EAP Username** - User name for EAP Console.

   - **EAP Password** - User account password for EAP Console.
    
   - **RHSM Username** - User name for RedHat account.

   - **RHSM Password** - User account password for RedHat account.
   
   - **RHSM Pool ID** - RedHat subscription Manager Pool ID (must contain JBoss EAP entitlement)
    
   - **SSH Key Data** - Generate an SSH key using Puttygen and provide the data here.
   
   - **VM Size** - Choose the size of the VM from the options in dropdown

   - Leave the rest of the Parameter Value as it is and proceed.

<img src="images/parameters.png" width="800">

## Deployment Time 

The deployment takes about 10 minutes to complete.

<img src="images/deploySucceeded.png" width="800">

## Post Deployment Steps

- Once the deployment is successfull, click on the "Outputs" to see the URL of the SSH Command, App WEB URLs:

<img src="images/templateOutput.png" width="800">

- Copy the string from the "sshCommand" field. Open a termial tool(or cmd window) and paste the string to access a VM on Azure cloud.

- Enter the VM Username and Password, the "Admin User" and "Admin Password" you provided before you deployed the template.

- Once you login into the VM, you can go through a server.log on JBoss EAP how Jgroup discovery works for clustering:

<img src="images/ssh_command.png" width="800">

-When you look at one of server logs ( i.e. node1 or node2 ), you should be able to identify the JGroups cluster members being added `Received new cluster view:`

<img src="images/session-replication-logs.png" width="800">

- Copy the App URL from the output section of the template. Open a web browser and paste the link, You will see Testing EAP Session Replication web page.

<img src="images/session-application-app0.png" width="800">

- The web application displays the Session ID, Session `counter` and `timestamp` (these are variables stored in the session that are replicated) and the container name that the web page and session is being hosted from.

- Now, select the **Increment Counter** link. The session variable will increase.

<img src="images/session-replication-increment.png" width="800">

## Notes
