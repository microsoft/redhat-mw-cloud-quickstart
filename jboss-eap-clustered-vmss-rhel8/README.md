# Red Hat - JBoss EAP 7.2 on RHEL 8.0 VMSS (clustered)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-clustered-vmss-rhel8%2Fazuredeploy.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-clustered-vmss-rhel8%2Fazuredeploy.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/>
</a>

<a href="https://github.com/SpektraSystems/redhat-mw-cloud-quickstart/blob/master/jboss-eap-clustered-vmss-rhel8/azuredeploy.json" target="_blank"> [Red Hat - JBoss EAP 7.2 on RHEL 8.0 VMSS (clustered)]</a> - Template for Red Hat - JBoss EAP 7.2 on RHEL 8.0 VMSS (clustered)

`Tags: JBoss, Red Hat, EAP 7.2, Cluster, Load Balancer, RHEL 8.0, Azure, Azure VMSS, Java EE`

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

This Azure quickstart template creates all of the compute resources to run a web application called eap-session-replication on JBoss EAP 7.2 cluster running on RHEL 8.0 VMSS instances where user can decide the number of intances to be deployed and scale it according to their requirement.

## Template Solution Architecture

This template creates all the Azure compute resources to run JBoss EAP 7.2 cluster on top RHEL 8.0 VMSS instances where user can decide the number of intances to be deployed and scale it according to their requirement. The following resources are created by this template:

- RHEL 8.0 VMSS instances
- 1 Load balancer
- Public IP for Load Balancer
- Virtual Network with single subnet
- JBoss EAP 7.2
- Sample application called eap-session-replication deployed on JBoss EAP 7.2
- Network Security Group
- Storage Account