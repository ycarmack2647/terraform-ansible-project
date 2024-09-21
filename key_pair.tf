# key_pair.tf
resource "aws_key_pair" "admin_key" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.public_key_path)
}