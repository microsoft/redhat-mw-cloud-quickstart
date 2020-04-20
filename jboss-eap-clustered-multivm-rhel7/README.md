# Red Hat - JBoss EAP 7.2 on RHEL 7.7 VM (clustered, multi-VM)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-clustered-multivm-rhel7%2Fazuredeploy.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-clustered-multivm-rhel7%2Fazuredeploy.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/>
</a>

`Tags: JBoss, Red Hat, EAP 7.2, Cluster, Load Balancer, RHEL 7.7, Azure, Azure VM, Java EE`

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

This Azure quickstart template deploys a web application called eap-session-replication on JBoss EAP 7.2 cluster running on 2 RHEL 7.7 VMs which are added to the backend pool of a Load Balancer.

## Template Solution Architecture

This template creates all of the compute resources to run JBoss EAP 7.2 cluster on top of 2 RHEL 7.7 VMs which are added to the backend pool of a Load Balancer. The following resources are created by this template:

- 2 RHEL 7.7 VMs
- 1 Load balancer
- 3 Public IPs
- Virtual Network with 2 subnets
- JBoss EAP 7.2
- Sample application called eap-session-replication deployed on JBoss EAP 7.2
- Network Security Group
- Storage Account

Following is the Architecture:

![alt text](images/arch.png)

To learn more about JBoss Enterprise Application Platform, visit:
https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/

## Licenses, Subscriptions and Costs

The RHEL 7.7 is Pay-As-You-Go image which carries a separate hourly charge that is in addition to Microsoft's Linux VM rates. Total price of the VM consists of the base Linux VM price plus RHEL VM image surcharge. See [Red Hat Enterprise Linux pricing](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/red-hat/) for details. You also need to have a Red Hat account to register to Red Hat Subscription Manager (RHSM) and install JBoss EAP. Click [here](https://access.redhat.com/products/red-hat-subscription-management) to know more about RHSM and pricing.

## Prerequisites

1. Azure Subscription with the specified payment method (RHEL 7.7 is an [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/RedHat.RedHatEnterpriseLinux77-ARM?tab=Overview) product and requires payment method to be specified in Azure Subscription)

2. To deploy the template, you will need to:

    - Choose an admin username and password/ssh key for your VM.  

    - Choose JBoss EAP username and password to enable the JBoss EAP manager UI and deployment method.

    - Provide your RHSM username and password
    
## Deployment Steps

Build your environment with JBoss EAP 7.2 cluster on top of 2 RHEL 7.7 VMs which is added to the backend pool of the Load Balancer on Azure in a few simple steps:  
1. Launch the template by clicking the Deploy to Azure button.  
2. Fill in the following parameter values and accept the terms and conditions before clicking on Purchase.

    - **Subscription** - Choose the appropriate subscription where you would like to deploy.

    - **Resource Group** - Create a new Resource Group or you can select an existing one.

    - **Location** - Choose the appropriate location for your deployment.

    - **Admin Username** - User account name for logging into your RHEL VM.
    
    - **Authentication Type** - Type of authentication to use on the Virtual Machine.

    - **Admin Password or Key** - User account password/ssh key for logging into your RHEL VM.

    - **JBoss EAP Username** - Username for JBoss EAP Console.

    - **JBoss EAP Password** - User account password for JBoss EAP Console.

    - **RHSM Username** - Username for the Red Hat account.

    - **RHSM Password** - User account password for the Red Hat account.
   
    - **RHSM Pool ID** - Red Hat subscription Manager Pool ID.

    - **VM Size** - Choose the appropriate size of the VM from the dropdown options.

    - Leave the rest of the parameter values as it is and proceed to purchase.
    
## Deployment Time 

The deployment takes approximately 10 minutes to complete.

## Validation Steps

- Once the deployment is successful, go to the outputs section of the deployment.

  ![alt text](images/outputs.png)

- To obtain the Public IP of a VM, go to the VM details page. Under settings go to Networking section and copy the NIC Public IP. Open a web browser and go to http://<PUBLIC_HOSTNAME>:8080 and you should see the web page:

  ![alt text](images/eap.png)

- To access the administration console, copy the Admin Console link in the output page and paste it in a browser. Now click on the link Administration Console and enter JBoss EAP username and password to see the console of the respective VM.

  ![alt text](images/eap-admin-console.png)

- To access the LB App UI console, copy the AppUI-LB and paste it in a browser. To access the VM App UI console, use the AppUI-1/AppUI-2. The web application displays the Session ID, `Session counter` and `timestamp` (these are variables stored in the session that are replicated) and the container name that the web page and session is being hosted from. Clicking on the Increment counter updates the session counter.

  ![alt text](images/eap-session-rep.png)

- Note that in the EAP Session Replication page of Load Balancer, the private IP displayed is that of either one VMs. When you stop/restart that VM1 and click on increment counter/refresh button, the private IP displayed will change to the other but the session ID remains the same which shows that the session ID got replicated.

  ![alt text](images/eap-ses-rep.png)

## Support

For any support related questions, issues or customization requirements, please contact info@spektrasystems.com
