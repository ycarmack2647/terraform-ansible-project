# ec2_instances.tf
resource "aws_instance" "web_server" {
  ami                    = "ami-0e54eba7c51c234f6" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.admin_key.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = { Name = "${var.project_name}-web-server" }
}