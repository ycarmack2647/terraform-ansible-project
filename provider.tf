# Default AWS provider configuration (replace with your default region)
provider "aws" {
  region = "us-east-1"  # e.g., "us-west-2"
}

# Provider configuration for the us-east-1 region
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
