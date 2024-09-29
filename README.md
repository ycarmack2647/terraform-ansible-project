Static Website Deployment on AWS using Terraform and Ansible
Overview

This project automates the deployment of a static website on AWS using Terraform for infrastructure provisioning and Ansible for configuration management. It demonstrates a complete Infrastructure as Code (IaC) workflow, utilizing various AWS services such as VPC, EC2, NAT Gateway, Application Load Balancer, and more.
Project Architecture

    VPC with public and private subnets in 2 availability zones.
    NAT Gateway for enabling internet access from the private subnet.
    Bastion Host in the public subnet for securely accessing servers in the private subnet.
    Application Load Balancer (ALB) to distribute traffic across EC2 instances in multiple availability zones.
    Ansible Server in the private subnet to manage web servers via Ansible.
    Web Servers (EC2 instances) hosting the static website.
    Route 53 for domain management and DNS routing.
    AWS Certificate Manager (ACM) for securing web traffic with SSL/TLS certificates.

Prerequisites

    Git installed on your local machine.
    Visual Studio Code or any code editor.
    GitHub account for version control.
    AWS Key Pair generated on the AWS Management Console for secure SSH connections.
    Terraform and Ansible installed locally.

Steps to Deploy
1. Clone the Repository

Clone the GitHub repository on both your local machine and the Ansible Server.

bash

git clone https://github.com/your-username/your-repository.git

2. Set up Terraform

Configure the infrastructure using Terraform:

    Create a VPC with public and private subnets.
    Deploy NAT Gateway, Bastion Host, and ALB in public subnets.
    Launch EC2 instances for the Ansible server and
    Navigate to the Terraform directory and run:

bash

terraform init
terraform apply

3. Set Up Ansible

Once the infrastructure is in place:

    SSH into the Bastion Host, then into the Ansible Server.
    Install Ansible on the Ansible Server.
    Add your private key pair to the Ansible Server for SSH connections to the web servers.
    Test connectivity between the Ansible Server and web servers.

bash

ansible -i inventory.ini all -m ping

4. Create and Run Ansible Playbooks

Create the Ansible playbooks for configuring the web servers and deploying the static website.

Example command:

bash

ansible-playbook -i inventory.ini playbook.yml

5. Test and Validate

    Verify that the website is accessible via the Application Load Balancer.
    Ensure the domain name is configured properly in Route 53.
    Check that the SSL/TLS certificates from AWS Certificate Manager are applied for secure web communication.

Key Learnings

    Key pair forwarding from the local computer to the Bastion Host and Ansible Server, with the public key added to the Ansible Server.
    Automated deployment with Terraform and configuration management with Ansible.
    Enhanced security and scalability using AWS services and Ansible.

Tools and Technologies Used

    Terraform
    Ansible
    AWS VPC
    EC2 Instances
    NAT Gateway
    Application Load Balancer (ALB)
    Route 53
    AWS Certificate Manager
    Git and GitHub

Future Improvements

    Use Ansible Vault for managing sensitive credentials.
    Explore Ansible Tower for centralized management.
    Add Auto Scaling to improve scalability during high traffic.

Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.
