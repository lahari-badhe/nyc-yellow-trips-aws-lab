terraform {
  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.0" }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" { type = string }
variable "db_password" { type = string }

# Generates a stable random suffix so bucket names are unique.
resource "random_id" "suffix" {
  byte_length = 3
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "lahari-day5-nyctaxi-dev-raw-${random_id.suffix.hex}"
}

module "lambda" {
  source        = "../../modules/lambda"
  function_name = "lahari-day5-dev-hello"
  s3_bucket     = module.s3.bucket_name
}

module "rds" {
  source      = "../../modules/rds"
  identifier  = "lahari-day5-dev-postgres"
  db_name     = "day5nyc"
  db_user     = "adminuser"
  db_password = var.db_password
}

output "day5_dev_bucket" { value = module.s3.bucket_name }
output "day5_dev_lambda" { value = module.lambda.lambda_name }
output "day5_dev_rds_endpoint" { value = module.rds.rds_endpoint }
