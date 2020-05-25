---
title: Quickstart - JBoss EAP on Azure for enterprise Java apps
description: Deploy JBoss EAP on Azure on Red Hat Enterprise Linux VM for enterprise Java apps
author: SpektraSystems
ms.author: <To be Updated>
ms.topic: quickstart
ms.date: 05/11/2020
---

# Quickstart: JBoss EAP on Azure for enterprise Java apps

This quickstart shows you how to deploy JBoss EAP on top of Red Hat Enterprise Linux. JBoss EAP (Enterprise Application Platform) is an open source platform for highly transactional, web-scale Java applications. EAP includes everything needed to build, run, deploy, and manage enterprise Java applications in a variety of environments, including on-premise, virtual environments, and in private, public, and hybrid clouds.

## Prerequisites

* Azure Subscription with the specified payment method (RHEL 7.7/8.0 is an [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps?filters=partners%3Blinux&page=1&search=Red%20Hat%20Enterprise%20Linux) product and requires a payment method to be specified in the Azure Subscription). Note that you will not be able to deploy Red Hat Enterprise Linux in MSDN subscription.
* To install JBoss EAP, you need to have an Red Hat Account and your Red Hat Subscription Management (RHSM) account needs EAP entitlement to use the Enterprise Application Platform. Set up an account on the [Red Hat Customer Portal](https://access.redhat.com/). You can get an evaluation account for EAP from [here](https://access.redhat.com/products/red-hat-jboss-enterprise-application-platform/evaluation).

## Use case

Red Hat JBoss Enterprise Application Platform (JBoss EAP) 7.2 is a certified implementation of the Java Enterprise Edition (Java EE) 8 specification. JBoss EAP provides preconfigured options for features such as high-availability clustering, messaging, and distributed caching. It also enables users to write, deploy, and run applications using the various APIs and services that JBoss EAP provides. Check the features of JBoss EAP [here](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/html-single/introduction_to_jboss_eap/index#about_eap).

JBoss EAP 7.2 can used to develop the following Applications:

* Web Services Applications - Web services provide a standard means of interoperating among different software applications. Each application can run on a variety of platforms and frameworks. Web services facilitate internal, heterogeneous subsystem communication. To know more about Developing Web Services Applications click [here](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/html/developing_web_services_applications/index).

* EJB Applications - Enterprise JavaBeans (EJB) 3.2 is an API for developing distributed, transactional, secure and portable Java EE applications through the use of server-side components called Enterprise Beans. Enterprise Beans implement the business logic of an application in a decoupled manner that encourages reuse. To know more about Developing EJB Applications click [here](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/html/developing_ejb_applications/index).

* Hibernate Applications - Developers and administrators can develop and deploy JPA/Hibernate applications with Red Hat JBoss Enterprise Application Platform. Hibernate Core is an object-relational mapping framework for the Java language. It provides a framework for mapping an object-oriented domain model to a relational database, allowing applications to avoid direct interaction with the database. Hibernate EntityManager implements the programming interfaces and lifecycle rules as defined by the [Java Persistence 2.1 specification](https://www.jcp.org/en/jsr/detail?id=338). Together with Hibernate Annotations, this wrapper implements a complete (and standalone) JPA persistence solution on top of the mature Hibernate Core. To know more about Developing JPA/Hibernate Applications click [here](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/html/developing_hibernate_applications/index).

## Configuration choice

For deployment of RHEL VM you can either choose the VM image from the [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us) which is basically a PAYG image or if you have a RHEL OS license of your own and wish to use that, then you can also deploy a RHEL VM of BYOS license type and use your license to register for RHEL OS.

In addition to providing functionality and APIs to its applications, JBoss EAP has powerful management capabilities. These management capabilities differ depending on which operating mode is used to start JBoss EAP. JBoss EAP is supported on Red Hat Enterprise Linux, Windows Server, and Oracle Solaris. JBoss EAP offers a standalone server operating mode for managing discrete instances and a managed domain operating mode for managing groups of instances from a single control point. You can declare an environment variable named *EAP_HOME* which is used to denote the path to the JBoss EAP installation. 

- **Start JBoss EAP as a Standalone Server** - Following is the command to start EAP service in Standalone Mode.

    `$EAP_HOME/bin/standalone.sh`
    
    This startup script uses the EAP_HOME/bin/standalone.conf file, to set some default preferences, such as JVM options. You can customize the settings in this file. JBoss EAP uses the standalone.xml configuration file to start on Standalone mode by default, but can be started using a different one. For details on the available standalone configuration files and how to use them, see the [Standalone Server Configuration Files](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/html/configuration_guide/jboss_eap_management#standalone_server_configuration_files) section. To start JBoss EAP with a different configuration, use the --server-config argument. For example:
    
    `$EAP_HOME/bin/standalone.sh --server-config=standalone-full.xml`
    
    For a complete listing of all available startup script arguments and their purposes, use the --help argument or see the [Server Runtime Arguments](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/html/configuration_guide/reference_material#reference_of_switches_and_arguments_to_pass_at_server_runtime) section.
    
- **Start JBoss EAP in a Managed Domain** - The domain controller must be started before the servers in any of the server groups in the domain. Use the following script to first start the domain controller, and then for each associated host controller.

    `$EAP_HOME/bin/domain.sh`
    
    This startup script uses the EAP_HOME/bin/domain.conf file, to set some default preferences, such as JVM options. You can customize the settings in this file. JBoss EAP uses the host.xml host configuration file to start on managed domain by default, but can be started using a different one. For details on the available managed domain configuration files and how to use them, see the [Managed Domain Configuration Files](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/html/configuration_guide/jboss_eap_management#managed_domain_configuration_files) section. To start JBoss EAP with a different configuration, use the --host-config argument. For example:
    
    `$EAP_HOME/bin/domain.sh --host-config=host-master.xml`
    
    When setting up a managed domain, additional arguments will need to be passed into the startup script. For a complete listing of all available startup script arguments and their purposes, use the --help argument or see the [Server Runtime Arguments](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/html/configuration_guide/reference_material#reference_of_switches_and_arguments_to_pass_at_server_runtime) section.
    
JBoss EAP can also work in Cluster, please check [JBoss EAP Clustering](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/html/configuring_messaging/clusters_overview) to know more.

> Note that this quickstart tells you how to deploy 11 templates mentioned below in *ARM Template* section and none of them are deploys JBoss EAP in Domain Server mode.

## Support and subscription notes

If you select the RHEL OS License type as PAYG (Pay-As-You-Go), this template uses the On-Demand Red Hat Enterprise Linux Pay-As-You-Go image from the Azure Gallery.

> When using the On-Demand image, there is an additional hourly RHEL subscription charge for using this image on top of the normal compute, network and storage costs. At the same time, the instance will be registered to your Red Hat subscription, so you will also be using one of your entitlements. This will lead to "double billing". To avoid this, you would need to build your own RHEL image, which is defined in this [Red Hat KB article](https://access.redhat.com/articles/uploading-rhel-image-to-azure).

If you have a valid Red Hat subscription, register for Cloud Access, [request access](https://access.redhat.com/public-cloud) to the BYOS RHEL image in the Private Azure Marketplace and follow the below mentioned steps to avoid the double billing.

Check [Red Hat Enterprise Linux pricing](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/red-hat/) for details on the VM price.

You can select the RHEL OS License type as BYOS (Bring-Your-Own-Subscription) for deploying the template to avoid double billing. Your RHSM account must have both Red Hat Enterprise Linux entitlement (for subscribing the RHEL OS for the VM) and EAP entitlement and you will have to enter both the pool IDs as mentioned in the template. To provision the RHEL-BYOS VM in your subscription, you will have to enable it in the Cloud Access from Red Hat portal and activate Red Hat Gold Images for your subscription. You can enable subscription for cloud access by following the instructions mentioned [here](https://access.redhat.com/documentation/en-us/red_hat_subscription_management/1/html/red_hat_cloud_access_reference_guide/con-enable-subs) and activate the Red Hat Gold Images by following the instructions mentioned [here](https://access.redhat.com/documentation/en-us/red_hat_subscription_management/1/html/red_hat_cloud_access_reference_guide/using_red_hat_gold_images#con-azure-access). Once your Azure subscription is enabled, please follow this [link](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/redhat/byos) to accept the Marketplace terms for RHEL-BYOS image from your Azure subscription.

Note that in both the cases your RHSM account needs EAP entitlement to use the Enterprise Application Platform. You can get an evaluation account for EAP from [here](https://access.redhat.com/products/red-hat-jboss-enterprise-application-platform/evaluation).

Click [here](https://access.redhat.com/products/red-hat-subscription-management) to know more about RHSM.

## How to consume

You can deploy the template in three following ways :

- Using Powershell : You can use powershell to deploy the template by running the following commands. Please check [here](https://docs.microsoft.com/en-us/powershell/azure/?view=azps-2.8.0) to install and configure Azure PowerShell.

    `New-AzResourceGroup -Name <resource-group-name> -Location <resource-group-location> #use this command when you need to create a new resource group for your deployment`

    `New-AzResourceGroupDeployment -ResourceGroupName <resource-group-name> -TemplateUri <raw link to the template which can be obtained from github>`
    
- Using Azure CLI : You can use Azure CLI to deploy the template by running the following commands. Please check [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) to install and configure the Azure Cross-Platform Command-Line Interface.

    `az group create --name <resource-group-name> --location <resource-group-location> #use this command when you need to create a new resource group for your deployment`

    `az group deployment create --resource-group <my-resource-group> --template-uri <raw link to the template which can be obtained from github>`

- Using Azure Portal : You can use Azure portal to deploy the template by going to the GitHub links mentioned below in *ARM Template* section and clicking on **Deploy to Azure** button.

## ARM template

* <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap-standalone-rhel7" target="_blank"> JBoss EAP 7.2 on RHEL 7.7 (stand-alone VM)</a> - This Azure template deploys a web application named JBoss-EAP on Azure on JBoss EAP 7.2 running on RHEL 7.7 VM.

* <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap-standalone-rhel8" target="_blank"> JBoss EAP 7.2 on RHEL 8.0 (stand-alone VM)</a> - This Azure template deploys a web application named JBoss-EAP on Azure on JBoss EAP 7.2 running on RHEL 8.0 VM.

* <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss7.3-eap-standalone-rhel8" target="_blank"> JBoss EAP 7.3 on RHEL 8.0 (stand-alone VM)</a> - This Azure template deploys a web application named JBoss-EAP on Azure on JBoss EAP 7.3 running on RHEL 8.0 VM.

* <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap-multinode-singlevm-rhel7" target="_blank"> JBoss EAP 7.2 on RHEL 7.7 (multi-node, single VM)</a> - This Azure template deploys a web application called eap-session-replication on JBoss EAP 7.2 running on multinode of RHEL 7.7 VM.

* <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap-multinode-singlevm-rhel8" target="_blank">JBoss EAP 7.2 on RHEL 8.0 (multi-node, single VM)</a> - This Azure template deploys a web application called eap-session-replication on JBoss EAP 7.2 running on multinode of RHEL 8.0 VM.

* <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap-clustered-multivm-rhel7" target="_blank">JBoss EAP 7.2 on RHEL 7.7 (clustered, multi-VM)</a> - This Azure template deploys a web application called eap-session-replication on JBoss EAP 7.2 cluster running on 'n' number RHEL 7.7 VMs where n is decided by the user and all the VMs are added to the backend pool of a Load Balancer.

* <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap-clustered-multivm-rhel8" target="_blank">JBoss EAP 7.2 on RHEL 8.0 (clustered, multi-VM)</a> - This Azure template deploys a web application called eap-session-replication on JBoss EAP 7.2 cluster running on 'n' number of RHEL 8.0 VMs where n is decided by the user and all the VMs are added to the backend pool of a Load Balancer.

* <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap7.3-clustered-multivm-rhel8" target="_blank"> JBoss EAP 7.3 on RHEL 8.0 (clustered, multi-VM)</a> - This Azure template deploys a web application called eap-session-replication on JBoss EAP 7.3 cluster running on 'n' number of RHEL 8.0 VMs where n is decided by the user and all the VMs are added to the backend pool of a Load Balancer.

* <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap-clustered-vmss-rhel7" target="_blank"> JBoss EAP 7.2 on RHEL 7.7 (clustered, VMSS)</a> - This Azure template deploys a web application called eap-session-replication on JBoss EAP 7.2 cluster running on RHEL 7.7 VMSS instances.

* <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap-clustered-vmss-rhel8" target="_blank">JBoss EAP 7.2 on RHEL 8.0 (clustered, VMSS)</a> - This Azure template deploys a web application called eap-session-replication on JBoss EAP 7.2 cluster running on RHEL 8.0 VMSS instances.

* <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/jboss-eap7.3-clustered-vmss-rhel8" target="_blank">JBoss EAP 7.3 on RHEL 8.0 (clustered, VMSS)</a> - This Azure template deploys a web application called eap-session-replication on JBoss EAP 7.3 cluster running on RHEL 8.0 VMSS instances.

## Resource Links:

Know more about [JBoss EAP](https://developers.redhat.com/products/eap/download?sc_cid=701f2000000Rm3wAAC&gclid=CjwKCAjwqpP2BRBTEiwAfpiD--4IvtzM8fywpF7LklGMbg2VKhQOvMoihdl22EVPj8RRLDlt8z8QcRoCwOYQAvD_BwE&gclsrc=aw.ds)

## Next steps

To learn more about JBoss EAP 7.2, visit: https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/

To learn more about JBoss EAP 7.3, visit: https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.3/

To learn more about Red Hat Subscription Management (RHSM), visit: https://access.redhat.com/products/red-hat-subscription-management

To learn more about Red Hat on Azure, visit: https://azure.microsoft.com/en-us/overview/linux-on-azure/red-hat/

You can deploy Red Hat Enterprise Linux (RHEL) 7.7 on Azure from [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/RedHat.RedHatEnterpriseLinux77-ARM?tab=Overview)

You can deploy Red Hat Enterprise Linux (RHEL) 8.0 on Azure from [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/RedHat.RedHatEnterpriseLinux80-ARM?tab=Overview)

If you don't have a Red Hat subscription to install a JBoss EAP, you can go through WildFly instead of JBoss EAP:

*  <a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/tree/master/wildfly-standalone-centos8" target="_blank"> WildFly 18 on CentOS 8 (stand-alone VM)</a> - Standalone WildFly 18 with a sample web app on a CentOS 8 Azure VM.
