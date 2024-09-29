# Replace with your domain name
variable "domain_name" {
  type    = string
  default = "shonproject101.com"
}

# Data source to find the existing ACM certificate by domain name
data "aws_acm_certificate" "existing_cert" {
  provider    = aws.us_east_1
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

# Alternatively, if you know the certificate ARN, you can use:
# data "aws_acm_certificate" "existing_cert" {
#   provider = aws.us_east_1
#   arn      = "aws:acm:us-east-1:accountnumber:certificate" # Put your arn for the acm
# }
