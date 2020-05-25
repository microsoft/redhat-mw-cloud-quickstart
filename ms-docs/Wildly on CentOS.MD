---
title: Quickstart - WildFly on CentOS
description: Deploy WildFly on a CentOS VM
author: SpektraSystems
ms.author: karler
ms.topic: quickstart
ms.date: 05/11/2020
---

# Quickstart: WildFly on CentOS

This quickstart shows you how to deploy standalone node of WildFly on top of CentOS 8 VM. This is ideal for development and testing of enterprise Java applications on Azure.

## Prerequisites

* An Azure subscription; if you don't already have an Azure subscription, you can activate your [MSDN subscriber benefits](https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details) or sign up for a [free Azure account](https://azure.microsoft.com/pricing/free-trial).

## Use case

WildFly is ideal for development and testing of enterprise Java applications on Azure. List of technologies available in WildFly 18 server configuration profiles is listed in the table in https://docs.wildfly.org/18/Getting_Started_Guide.html#getting-started-with-wildfly.

You can also use WildFly in Standalone mode and in Cluster mode as per your use case. You can ensure high availability of critical Jakarta EE applications by WildFly on a cluster of nodes, making a small number of application configuration changes, and then deploying the application in the cluster. To learn more on this please check https://docs.wildfly.org/18/High_Availability_Guide.html

## Configuration choice

WildFly can be booted in two different modes.

* **Standalone Server** - A standalone server instance is an independent process, much like an JBoss Application Server 3, 4, 5, or 6 instance is. Standalone instances can be launched via the standalone.sh or standalone.bat launch scripts. If more than one standalone instance is launched and multi-server management is desired, it is the user’s responsibility to coordinate management across the servers.

* **Managed Domain** - A collection of servers is referred to as the members of a "domain" with a single Domain Controller process acting as the central management control point. All of the WildFly instances in the domain share a common management policy, with the Domain Controller acting to ensure that each server is configured according to that policy. Domains can span multiple physical (or virtual) machines, with all WildFly instances on a given host under the control of a special Host Controller process. One Host Controller instance is configured to act as the central Domain Controller. The Host Controller on each host interacts with the Domain Controller to control the lifecycle of the application server instances running on its host and to assist the Domain Controller in managing them. When you launch a WildFly managed domain on a host via the domain.sh or domain.bat launch scripts you launch a Host Controller and usually at least one WildFly instance.

You can also start WildFly instance with Alternate Configuration by using configuration files available in configuration folder.

Following are the Standalone Server Configuration files

- standalone.xml (default)
   
   - This is the default file used for starting the WildFly instance. It contains Jakarta web profile certified configuration with the required technologies.
   
- standalone-ha.xml

   - Jakarta web profile certified configuration with high availability.
   
- standalone-full.xml

   - Jakarta Full Platform certified configuration including all the required technologies

- standalone-full-ha.xml

   - Jakarta Full Platform certified configuration with high availability
   
Following are the Domain Server Configuration files
 
- domain.xml
   
   - Jakarta full and web profiles available with or without high availability

It is very important to note that the domain and standalone modes determine how the servers are managed and not what capabilities they provide.

If you choose to start your WildFly Standalone server with one of the other provided configurations, they can be accessed by passing the --server-config argument with the server-config file to be used. 

For example, to use the Full Platform with clustering capabilities use the following command:

`./standalone.sh --server-config=standalone-full-ha.xml`

Similarly to start an alternate configuration in domain mode:

`./domain.sh --domain-config=my-domain-configuration.xml`

You know more on the configurations you can check https://docs.wildfly.org/18/Getting_Started_Guide.html#wildfly-10-configurations.

> Note that this template deploys a WildFly in Standalone mode.

## Support and subscription notes

Azure CentOS 8 image is a Pay-as-you-go (PAYG) VM image and does not require the user to license. The VM will be licensed automatically after the instance is launched for the first time and user will be charged hourly in addition to Microsoft's Linux VM rates. Click [here](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/#linux) for pricing details. WildFly is free to download and use and does not require a Red Hat Subscription or any License.

## How to consume

You can deploy the template in three following ways :

- Using Powershell : You can use powershell to deploy the template by running the following commands. Please check [here](https://docs.microsoft.com/en-us/powershell/azure/?view=azps-2.8.0) to install and configure Azure PowerShell.

    `New-AzResourceGroup -Name <resource-group-name> -Location <resource-group-location> #use this command when you need to create a new resource group for your deployment`

    `New-AzResourceGroupDeployment -ResourceGroupName <resource-group-name> -TemplateUri https://raw.githubusercontent.com/SpektraSystems/redhat-mw-cloud-quickstart/master/wildfly-standalone-centos8/azuredeploy.json`
    
- Using Azure CLI : You can use Azure CLI to deploy the template by running the following commands. Please check [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) to install and configure the Azure Cross-Platform Command-Line Interface.

    `az group create --name <resource-group-name> --location <resource-group-location> #use this command when you need to create a new resource group for your deployment`

    `az group deployment create --resource-group <my-resource-group> --template-uri https://raw.githubusercontent.com/SpektraSystems/redhat-mw-cloud-quickstart/master/wildfly-standalone-centos8/azuredeploy.json`

- Using Azure Portal : You can use Azure portal to deploy the template by clicking <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fwildfly-standalone-centos8%2Fazuredeploy.json" target="_blank">here</a> and logging into your Azure portal.

## ARM template

<a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/wildfly-standalone-centos8" target="_blank"> WildFly 18 on CentOS 8 (stand-alone VM)</a> - This is a quickstart template that creates a standalone node of WildFly 18.0.1.Final on CentOS 8 VM in your Resource Group (RG) which includes a Public DNS name, Virtual Network and Network Security Group. It also deploys Java Sample Application named JBoss-EAP on Azure on Wildfly.

## Resource Links:

Know more about [WildFly](https://wildfly.org/)

## Next steps

To learn more about the WildFly 18.0.0.Final, visit: https://docs.wildfly.org/18/.

If you're interested in Red Hat JBoss EAP Azure Quickstart templates, you can find it here:

*  <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap-standalone-rhel7" target="_blank"> JBoss EAP 7.2 on RHEL 7.7 (stand-alone VM)</a> - Standalone JBoss EAP 7.2 with a sample web app on a RHEL 7.7 Azure VM.

*  <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap-standalone-rhel8" target="_blank"> JBoss EAP 7.2 on RHEL 8.0 (stand-alone VM)</a> - Standalone JBoss EAP 7.2 with a sample web app on a RHEL 8.0 Azure VM.

*  <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss7.3-eap-standalone-rhel8" target="_blank"> JBoss EAP 7.3 on RHEL 8.0 (stand-alone VM)</a> - Standalone JBoss EAP 7.3 with a sample web app on a RHEL 8.0 Azure VM.