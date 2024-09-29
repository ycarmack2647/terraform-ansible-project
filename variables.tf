# variables.tf
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "terraform_ansible_project" {
  description = "Project name prefix"
  default     = "tf-ansible-demo"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "myproject" # You can set a default value or provide a value when running terraform
}

variable "my_ip_address" {
  description = "Your public IP address to allow SSH access"
  type        = string
  default     = "73.86.194.218" # Replace with your actual public IP address
}

# Example variables.tf
variable "ami_id" {
  description = "The Amazon Linux 2 AMI ID for your region"
  type        = string
  default     = "ami-0e54eba7c51c234f6" # Amazon Linux 2 AMI for us-east-1 (update for your region if needed)
}

variable "instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t2.micro"
}

# Security group reference
variable "bastion_sg_id" {
  description = "The security group ID for the Bastion host"
  type        = string
  default     = true
}

variable "public_subnet_az1_id" {
  description = "The public subnet ID in AZ1"
  type        = string
  default     = true
}

# Define variables in variables.tf

variable "ami_ubuntu_24_04" {
  description = "Ubuntu 24.04 LTS AMI ID"
  type        = string
  default     = "ami-0e86e20dae9224db8" # Replace with the actual AMI ID for Ubuntu 24.04 in your region
}

variable "private_app_subnet_az1_id" {
  description = "The private app subnet ID in AZ1"
  type        = string
  default     = true
}

# variables.tf

variable "ansible_sg_id" {
  description = "The security group ID for the Ansible server"
  type        = string
  default     = true
}

variable "ansible_public_key" {
  type    = string
  default = "mykey.pub"
}

variable "ansible_private_key" {
  type    = string
  default = "mykey"
}

variable "initial_private_key" {
  type    = string
  default = "id_rsa.pem"
}

variable "initial_public_key" {
  type    = string
  default = "id_rsa.pub" # Replace with your initial public key path
}














