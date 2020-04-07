# Red Hat - JBoss EAP 7.2 on RHEL 7.7 VM (single-VM)
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-clustered-singlevm-rhel7%2Fazuredeploy.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-clustered-singlevm-rhel7%2Fazuredeploy.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/>
</a>

`Tags: JBoss, Red Hat, EAP 7.2, Azure, Azure VM, JavaEE, RHEL 7.7`

<!-- TOC -->

1. [Solution Overview](#solution-overview)
2. [Template Solution Architecture](#template-solution-architecture)
3. [Licenses, Subscriptions and Costs](#licenses-subscriptions-and-costs)
4. [Prerequisites](#prerequisites)
5. [Deployment Steps](#deployment-steps)
6. [Deployment Time](#deployment-time)
7. [Validation Steps](#validation-steps)
8. [Support](#support)

<!-- /TOC -->

## Solution Overview

JBoss EAP (Enterprise Application Platform) is an open source platform for highly transactional, web-scale Java applications. EAP combines the familiar and popular Jakarta EE specifications with the latest technologies, like Microprofile, to modernize your applications from traditional Java EE into the new world of DevOps, cloud, containers, and microservices. EAP includes everything needed to build, run, deploy, and manage enterprise Java applications in a variety of environments, including on-premise, virtual environments, and in private, public, and hybrid clouds.

Red Hat Subscription Management (RHSM) is a customer-driven, end-to-end solution that provides tools for subscription status and management and integrates with Red Hat's system management tools. To obtain an rhsm account for JBoss EAP, go to: www.redhat.com and sign in.

This Azure quickstart template deploys a web application called eap-session-replication on JBoss EAP 7.2 running on RHEL 7.7 VM.

## Template Solution Architecture
This template creates all the Azure compute resources to run JBoss EAP 7.2 on top of RHEL 7.7 VM. The following resources are created by this template:

- RHEL 7.7 VM 
- Public IP 
- Virtual Network 
- Network Security Group 
- JBoss EAP 7.2
- Sample application called eap-session-replication deployed on JBoss EAP 7.2
- Storage Account

Following is the Architecture:

![alt text](images/eap-rhel-arch.png)

To learn more about JBoss Enterprise Application Platform, visit:
https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/


## Licenses, Subscriptions and Costs

The RHEL 7.7 is Pay-As-You-Go image which carries a separate hourly charge that is in addition to Microsoft's Linux VM rates. Total price of the VM consists of the base Linux VM price plus RHEL VM image surcharge. See [Red Hat Enterprise Linux pricing](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/red-hat/) for details. You also need to have a Red Hat account to register to Red Hat Subscription Manager (RHSM) and install JBoss EAP. Click [here](https://access.redhat.com/products/red-hat-subscription-management) to know more about RHSM and pricing.


## Prerequisites

1. Azure Subscription with the specified payment method (RHEL 7.7 is an [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/RedHat.RedHatEnterpriseLinux77-ARM?tab=Overview) product and requires the payment method to be specified in Azure Subscription)

2. To deploy the template, you will need to:

   - Choose an admin username and password for your VM.
    
   - Choose DNS Label Prefix for the public IP which should be unique. Note that this will also be the name of your VM.

   - Choose JBoss EAP username and password to enable the JBoss EAP manager UI and deployment method.
    
   - Provide your RHSM username and password

## Deployment Steps

Build your environment with JBoss EAP 7.2 on top of RHEL 7.7 on Azure by clicking the Deploy to Azure button and fill in the following parameter values:

   - **Subscription** - Choose the appropriate subscription where you would like to deploy.

   - **Resource Group** - Create a new Resource Group or you can select an existing one.

   - **Location** - Choose the appropriate location for your deployment.

   - **Admin Username** - User account name for logging into your RHEL VM.

   - **Authentication Type** - Type of authentication to use on the Virtual Machine.

   - **Admin Password or Key** - User account password/ssh key for logging into your RHEL VM.
   
   - **DNS Label Prefix** - DNS Label for the Public IP and this is also the name of your VM. Must be lowercase. It should match with the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$ or it will raise an error.

   - **JBoss EAP Username** - Username for JBoss EAP Console.

   - **JBoss EAP Password** - User account password for JBoss EAP Console.
    
   - **RHSM Username** - Username for the Red Hat account.

   - **RHSM Password** - User account password for the Red Hat account.
   
   - **RHSM Pool ID** - Red Hat subscription Manager Pool ID.
   
   - **VM Size** - Choose the appropriate size of the VM from the dropdown options.

   - Leave the rest of the parameter values as it is and accept the terms and conditions before clicking on Purchase.

## Deployment Time 

The deployment takes about 10 minutes to complete.

## Validation Steps

- Once the deployment is successful, click on the "Outputs" to see the URL of the SSH Command, App WEB URLs:

  ![alt text](images/template-output.png)

- Copy the string from the "sshCommand" field. Open command prompt and paste the string to access the VM.

- Enter the VM username and password/ssh key, the "Admin Username" and "Admin Password" you provided before you deployed the template.

- Once you login into the VM, you can go through the server.log on JBoss EAP how Jgroup discovery works for clustering:

  ![alt text](images/ssh-command.png)

- When you look at one of the server logs ( i.e. node1 or node2 ), you should be able to identify the JGroups cluster members being added `Received new cluster view:`

  ![alt text](images/session-replication-logs.png)

- Copy the App URL from the output section of the template. Open a web browser and paste the link, you will see EAP Session Replication web page.

  ![alt text](images/session-application-app.png)

- The web application displays the Session ID, `Session counter` and `timestamp` (these are variables stored in the session that are replicated) and the container name that the web page and session is being hosted from.

- Now, select the **Increment Counter** link. The session counter will increase. Note that the session counter increases simultaneously on both App UIs.

  ![alt text](images/session-replication-increment.png)

## Support

For any support related questions, issues or customization requirements, please contact info@spektrasystems.com
