resource "aws_instance" "bastion_host" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.admin_key.key_name
  subnet_id     = aws_subnet.public_subnet_az1.id

  # Correct: Use 'vpc_security_group_ids' when using 'subnet_id'
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  provisioner "file" {
    source      = "${path.module}/mykey"
    destination = "/home/ec2-user/.ssh/id_rsa"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.initial_private_key
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ec2-user/.ssh/id_rsa",
      "chown ec2-user:ec2-user /home/ec2-user/.ssh/id_rsa"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.initial_private_key
      host        = self.public_ip
    }
  }

  tags = {
    Name = "${var.project_name}-bastion-host"
  }
}


# Assuming you have a subnet resource defined:
resource "aws_subnet" "private_subnets_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.project_name}-private-app-subnet-az1"
  }
}

resource "aws_instance" "ansible_server" {
  ami           = "ami-0e86e20dae9224db8" # Ubuntu AMI ID
  instance_type = "t2.micro"              # e.g., "t2.micro"
  key_name      = "mykey"                 # SSH Key

  # Use the existing subnet ID
  subnet_id = "subnet-016979a346681f403" # Replace with the actual Subnet ID from AWS

  vpc_security_group_ids = [aws_security_group.ansible_sg.id] # Security group ID

  provisioner "file" {
    source      = "mykey.pub"
    destination = "/home/ec2-user/.ssh/authorized_keys"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.initial_private_key
      host        = self.private_ip

      bastion_host        = aws_instance.bastion_host.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = var.initial_private_key
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ec2-user/.ssh/authorized_keys",
      "chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.initial_private_key
      host        = self.private_ip

      bastion_host        = aws_instance.bastion_host.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = var.initial_private_key
    }
  }

  tags = {
    Name = "${var.project_name}-ansible-server"
    Role = "Ansible Server"
  }
}




# ec2_instances.tf

# Launch EC2 instance in private subnet AZ1
resource "aws_instance" "webserver_az1" {
  ami                         = "ami-0e54eba7c51c234f6" # Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.admin_key.key_name # Uses the Ansible key pair
  subnet_id                   = aws_subnet.private_subnet_az1.id
  vpc_security_group_ids      = [aws_security_group.webserver_sg.id]
  associate_public_ip_address = false # No public IP, since it's in a private subnet

  tags = {
    Name = "${var.project_name}-webserver-az1"
  }
}

# Launch EC2 instance in private subnet AZ2
resource "aws_instance" "webserver_az2" {
  ami                         = "ami-0e54eba7c51c234f6" # Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.admin_key.key_name # Uses the Ansible key pair
  subnet_id                   = aws_subnet.private_subnet_az2.id
  vpc_security_group_ids      = [aws_security_group.webserver_sg.id]
  associate_public_ip_address = false # No public IP, since it's in a private subnet

  tags = {
    Name = "${var.project_name}-webserver-az2"
  }
}
