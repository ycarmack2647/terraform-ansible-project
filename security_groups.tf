resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow inbound HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.main.id # Replace with your VPC ID

  # Allow inbound traffic on port 80 (HTTP)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  # Allow inbound traffic on port 443 (HTTPS)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}


resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-bastion-sg"
  description = "Allow SSH from my IP"
  vpc_id      = aws_vpc.main.id # Replace with your VPC ID

  # Allow inbound traffic on port 22 (SSH) from my IP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip_address}/32"] # Allow SSH only from your IP
    description = "Allow SSH from my IP address"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}

# security_groups.tf

resource "aws_security_group" "ansible_sg" {
  name        = "${var.project_name}-ansible-sg"
  description = "Security group for Ansible server"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow SSH from Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ansible-sg"
  }
}



resource "aws_security_group" "webserver_sg" {
  name        = "${var.project_name}-webserver-sg"
  description = "Allow HTTP/HTTPS from ALB SG and SSH from Ansible Server SG"
  vpc_id      = aws_vpc.main.id # Replace with your VPC ID

  # Allow HTTP (Port 80) from ALB Security Group
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Reference ALB Security Group
    description     = "Allow HTTP from ALB"
  }

  # Allow HTTPS (Port 443) from ALB Security Group
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Reference ALB Security Group
    description     = "Allow HTTPS from ALB"
  }

  # Allow SSH (Port 22) from Ansible Server Security Group
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ansible_sg.id] # Reference Ansible Server Security Group
    description     = "Allow SSH from Ansible Server"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.project_name}-webserver-sg"
  }
}

# security_groups.tf
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-alb-sg" }
}


