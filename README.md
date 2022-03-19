# Notejam AWS infrastructure

This repository contains an example of 2 infrastructures from on-premise to AWS Cloud.


## The AWS Infrastructure as Code

- The infrastructure code can be found in the Infrastructure folder
- The documentation/diagrams can be found in the Documents folder
- All the Terraform files can be used as module to be install for Test and Dev in further stage of the project



## About the Solution

- The app is starting using Python implementation on Flask framework. Thep prod environment is configured to have:
  - VPC 
  - 2 Subnets in two availability zones
  - Internet Gateway
  - Load Balancer to server the Auto scaling group e.g EC2 instances
  - Auto Scaling group configured to scale based on the needs 
  - Cloud Watch alarms attached to the Auto Scaling
  - DB configured as Multi-AZ to have a stand-by DB in case of a failure
  - DB password is randomly generated and uploaded in SSM as SecureString
  - Terraform State to be upload in S3 bucket ( Possible to be configured Dynamo DB with Locking mechanism to avoid mistakes while working on deploying )

- Further Improvements for the solution
  - Configuring Route53 to manage DNS names and ELB routes
  - AWS WAF can
  - To provide secure access to instances located in the private and public subnets, bastion host could be provisioned
  - For redundancy and reducing latency separate cluster in another region could be provisioned
  - In case of entire region disaster - incoming traffic could be shifted to another region using Route53 Failover Routing Policy
  - For DB high availability and reliability the MultiAZ configuration with one read replica can be used
  - For DB backups automatic snapshots once a day with 1 month retention period can be used



## Possible 2nd Solution

- In the Infrastructure folder you will find another folder called Kubernetes+ECR in that folder there is a Infrastructure code to build EKS cluster with ECR and also a CICD Pipeline which can automate deployment of the app based on push/merge to a repository ( This can be changed/reconfigured based on the needs).
- The Kubernetes Solution can be configured as follows:
  - Deployment Configuration with all necessary option e.g (Replicas, RollingDeployments,PV,PVC and many more)
  - The new code from the Developers can be easly depoloyed using the RollingUpdates which will update 1 pod at time to have 0 downtime
  - AWS LoadBalancer can be configured to server the Pods 
  - TOP can be installed as Demonset to all pods to ensure monitoring on pods and nodes (CPU/Memory)
  - All logs can be stored to Volume attached to the pods

