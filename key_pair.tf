# key_pair.tf

variable "public_key_path" {
  description = "Path to your Ansible public SSH key"
  default     = "~/.ssh/id_rsa.pub" # Update this to the path of your Ansible public key
}

variable "key_pair_name" {
  description = "The name of the existing key pair for SSH access"
  type        = string
  default     = "mykey" # Your key pair name for SSH access ansible server
}


resource "aws_key_pair" "admin_key" {
  key_name   = "admin_key1"
  public_key = file("~/.ssh/id_rsa.pub") # Update the path to your public key web servers
}
