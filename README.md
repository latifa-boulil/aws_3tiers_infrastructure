# AWS 3-TIER APPLICATION INFRASTRUCTURE


### Introduction
------------------

This project showcases the deployment of a highly scalable and resilient 3-tier architecture on AWS, fully automated using Terraform. The infrastructure includes everything from VPC configuration to fine-grained security rules, ensuring optimal performance and security. It is designed to support modern web applications with high availability and efficient resource management, making it ideal for dynamic workloads.

### Project Overview
---------------------

This project implements a robust 3-tier architecture designed for scalability, high availability, and security on AWS. The infrastructure consists of the following tiers:

* Frontend Tier (Public Subnet):
The frontend tier is deployed in a public subnet, utilizing an Application Load Balancer (ALB) to distribute incoming traffic efficiently across multiple instances. This ensures seamless user experience and redundancy. Auto Scaling is configured to dynamically adjust the number of instances based on workload

* Backend Tier (Private Subnet):
The backend tier operates in a secure private subnet, hosting the core business logic of the application. Auto Scaling is configured to dynamically adjust the number of instances based on workload. Instances in the backend tier access the internet securely through a NAT Gateway, which is deployed in the public subnet.

* Database Tier (Private Subnet):
The database tier resides in another private subnet, safeguarding sensitive data. Amazon RDS is used with built-in encryption to protect data at rest and in transit. Backups and automated failover capabilities further enhance data reliability.


### Key Features:
------------------

* High Availability:
The infrastructure spans multiple availability zones, providing redundancy and minimizing downtime in case of failures.

* Scalability:
Both the frontend and backend tiers leverage auto scaling. A CloudWatch alarm monitors CPU utilization and triggers scaling actions when usage exceeds or falls below predefined thresholds, ensuring performance and cost efficiency

* Enhanced Security:
Security Groups and IAM roles enforce strict access controls between tiers. Sensitive data is protected through encryption, and private subnets prevent unauthorized external access.

* State Management:
Terraform state is stored in a remote S3 backend, ensuring a secure and centralized location for managing the infrastructure state. This facilitates collaboration and provides state locking to prevent conflicts during deployments.

* Cost Optimization

    -- place diagram here --


### Project Structure
--------------------------

The project leverages an extensive modular structure to ensure scalability, reusability, and maintainability. Each module is designed to manage a specific part of the infrastructure, allowing for clear separation of concerns and simplified updates.

The project is organized into the following Terraform modules:
 
#### 1. VPC Module

The VPC Module is responsible for setting up the foundational networking infrastructure. It dynamically provisions resources based on the number of availability zones (AZs) specified in variables.tf, ensuring flexibility and scalability. The module includes the following components:

* VPC: Creates a Virtual Private Cloud to provide an isolated network environment for the application.
* Subnets: Dynamically provisions three types of subnets across all specified AZs using a for_each loop:

    * Public Subnets: For resources that require internet access (e.g., NAT Gateways, Load Balancers).
    * Private Subnets: For backend services that do not require direct internet access.
    * Database Subnets: Specifically designed for hosting RDS instances with no internet connectivity for added security.
* Internet Gateway (IGW): Allows resources in the public subnets to communicate with the internet.
* Elastic IP Addresses (EIPs): Allocates one Elastic IP for each AZ to ensure consistent internet-facing addresses for the NAT Gateways.
* NAT Gateways: Deploys one NAT Gateway per AZ in the public subnets. This allows instances in private and database subnets to initiate outbound internet connections securely (e.g., for updates).
* Route Tables and Associations: 
    * Public Route Table: Routes traffic from public subnets to the internet via the Internet Gateway.
    * Private Route Tables: Each private and database subnet is associated with its own route table, configured to route outbound traffic through the respective NAT Gateway in the corresponding AZ.


#### 2. Security Module

* Security Groups:
    * Frontend tier security group for public access.
    * Backend tier security group for restricted access from frontend.
    * Database tier security group for restricted access from backend.
* SSH Key: Public key associated with launch templates.

#### 3. Database Module

* RDS: Relational Database Service for the application’s database tier.
* DB Subnet Group: Ensures RDS is placed in private subnets.
* Database Credentials: Stored securely in prod.tfvars.

#### 4. Compute Module

* Elastic Load Balancers (ALB):
    * One for the frontend tier.
    * One for the backend tier.
* Launch Templates: Configured for EC2 instances in frontend and backend tiers.
* Auto Scaling Groups (ASG):
    Configured for both frontend and backend tiers.
    Ensures optimal instance count based on load.
    Auto Scaling Policies: Scale up and down based on CloudWatch Alarms.

#### 5 . Root project 

* Provider Configuration
    AWS Provider: Version 5.0
    Region: eu-west-3
    Availability Zones: eu-west-3a, eu-west-3b
* State Management
* Backend: Terraform state is stored in an S3 bucket to manage infrastructure changes securely and consistently.


## Prerequisites

List necessary tools and accounts:
Terraform (include version)
Cloud provider CLI (e.g., AWS CLI)
An active account with the cloud provider
Access to specific services (e.g., IAM roles, S3 for state management)

## Usage

Clone the Repository:
git clone <repository-url>
cd <repository-folder>
Initialize Terraform:

bash
Copier le code
terraform init
Plan the Infrastructure:

bash
Copier le code
terraform plan -var-file=prod.tfvars
Apply the Changes:

bash
Copier le code
terraform apply -var-file=prod.tfvars
Destroy the Infrastructure (if needed):

bash
Copier le code
terraform destroy -var-file=prod.tfvars

Outputs
Public IPs and DNS of ALBs.
RDS Endpoint for the database.
Auto Scaling Group details.

## BEST PRACTICES 

Include any relevant practices:

Use remote state for collaboration.
Manage secrets securely (e.g., AWS Secrets Manager)

All sensitive credentials are stored in encrypted files (prod.tfvars).
Least privilege principles applied for IAM roles.
Network segmentation via security groups and subnets.

## Troubleshooting
Provide solutions to common issues:

Error: Error: Cycle detected in module dependencies
Solution: Check for circular dependencies in your module configurations.

## Monitoring and Logging

CloudWatch Alarms: Monitors CPU utilization to trigger auto-scaling policies.
CloudWatch Logs: Collects logs for debugging and performance analysis.

## Future Improvements
Implement Terraform Cloud for collaboration.
Add WAF for enhanced security on ALBs.
Integrate Prometheus and Grafana for advanced monitoring.

## License
This project is open-source and available under the MIT License.

