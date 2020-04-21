# Red Hat - JBoss EAP 7.2 MultiNode on RHEL 8.0 single-VM
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-multinode-singlevm-rhel8%2Fazuredeploy.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-multinode-singlevm-rhel8%2Fazuredeploy.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/>
</a>

`Tags: JBoss, Red Hat, EAP 7.2, Azure, Azure VM, JavaEE, RHEL 8.0`

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

Red Hat Subscription Management (RHSM) is a customer-driven, end-to-end solution that provides tools for subscription status and management and integrates with Red Hat's system management tools. To obtain an rhsm account for JBoss EAP, go to: www.redhat.com.

This Azure quickstart template creates all of the compute resources to run a web application called eap-session-replication on JBoss EAP 7.2 running on RHEL 8.0 VM.

## Template Solution Architecture
This template creates all the Azure compute resources to run JBoss EAP 7.2 on top of RHEL 8.0 VM. The following resources are created by this template:

- RHEL 8.0 VM 
- Public IP 
- Virtual Network 
- Network Security Group 
- JBoss EAP 7.2
- Sample application called eap-session-replication deployed on JBoss EAP 7.2
- Storage Account

Following is the Architecture:

![alt text](images/eap-rhel-arch.png)

To learn more about the JBoss Enterprise Application Platform, visit:
https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/


## Licenses, Subscriptions and Costs

If you select the offer as Pay-As-You-Go, the template will deploy RHEL 8.0 Pay-As-You-Go image which carries a separate hourly charge that is in addition to Microsoft's Linux VM rates. In this case the VM will be licensed automatically after the instance is launched for the first time and total price of the VM consists of the base Linux VM price plus RHEL VM image surcharge. See [Red Hat Enterprise Linux pricing](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/red-hat/) for details. You also need to have a Red Hat account to register to Red Hat Subscription Manager (RHSM) and install JBoss EAP. To use the Enterprise Application Platform your RHSM account needs EAP entitlement. You can get an evaluation account for EAP from [here](https://access.redhat.com/products/red-hat-jboss-enterprise-application-platform/evaluation). If you select the Offer as BYOS for deploying the template, your RHSM account must have both Red Hat Enterprise Linux entitlement (for subscribing the RHEL OS for the VM) and EAP entitlement and you will have to enter both the pool IDs as mentioned in the template. Click [here](https://access.redhat.com/products/red-hat-subscription-management) to know more about RHSM and pricing.

## Prerequisites

1. Azure Subscription with the specified payment method (RHEL 8 is an [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/RedHat.RedHatEnterpriseLinux80-ARM?tab=Overview) product and requires a payment method to be specified in the Azure Subscription)

2. To deploy the template, you will need:

   - **Admin Username** and password/ssh key data which is an SSH RSA public key for your VM.
    
   - **DNS Label Prefix** for the public IP which should be unique. Note that this will also be the name of your VM.

   - **JBoss EAP Username** and password
    
   - **RHSM Username** and password

## Deployment Steps

Build your environment with JBoss EAP 7.2 on top of RHEL 8.0 on Azure by clicking the **Deploy to Azure** button and fill in the following parameter values:

   - **Subscription** - Choose the appropriate subscription where you would like to deploy.

   - **Resource Group** - Create a new Resource Group or you can select an existing one.

   - **Location** - Choose the appropriate location for your deployment.

   - **Admin Username** - User account name for logging into your RHEL VM.

   - **Authentication Type** - Type of authentication to use on the Virtual Machine.

   - **Admin Password or SSH Key** - User account password/ssh key data which is an SSH RSA public key for logging into your RHEL VM.
   
   - **DNS Label Prefix** - DNS Label for the Public IP and this is also the name of your VM. Must be lowercase. It should match with the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$ or it will raise an error.

   - **JBoss EAP Username** - Username for JBoss EAP Console.

   - **JBoss EAP Password** - User account password for JBoss EAP Console.

   - **Offer** - Choose the type of offer from the dropdown options for deploying your Virtual Machine.
    
   - **RHSM Username** - Username for the Red Hat account.

   - **RHSM Password** - User account password for the Red Hat account.
   
   - **RHSM Pool ID for EAP** - Red Hat Subscription Manager Pool ID (Should have EAP entitlement)

   - **RHSM Pool ID for RHEL OS** - Red Hat Subscription Manager Pool ID (Should have RHEL entitlement). Mandartory if you select the BYOS offer. You can leave it blank if you select offer Pay-As-You-Go

   - **VM Size** - Choose the appropriate size of the VM from the dropdown options.

   - Leave the rest of the parameter values (artifacts and Location) as is and accept the terms and conditions before clicking on Purchase.

## Deployment Time 

The deployment takes about 10 minutes to complete.

## Validation Steps

- Once the deployment is successful, click on the "Outputs" to see the URL of the SSH Command, App WEB URLs:

  ![alt text](images/template-output.png)

- Copy the string from the "sshCommand" field. Open terminal tool(or cmd window) and paste the string to access the VM.

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