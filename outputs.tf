output "webserver_az1_private_ip" {
  description = "Private IP address of webserver in AZ1"
  value       = aws_instance.webserver_az1.private_ip
}

output "webserver_az2_private_ip" {
  description = "Private IP address of webserver in AZ2"
  value       = aws_instance.webserver_az2.private_ip
}
