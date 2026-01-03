variable "enable_rds" {
  type        = bool
  description = "If true, create the RDS instance. If false, skip it."
  default     = false
}
variable "identifier"  { type = string }
variable "db_name"     { type = string }
variable "db_user"     { type = string }
variable "db_password" { type = string }

resource "aws_db_instance" "this"{
  count = var.enable_rds ? 1 : 0
  identifier          = var.identifier
  engine              = "postgres"
  engine_version      = "15"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20

  db_name             = var.db_name
  username            = var.db_user
  password            = var.db_password

  publicly_accessible = true
  skip_final_snapshot = true
}

output "rds_endpoint" {
  value       = var.enable_rds ? aws_db_instance.this[0].endpoint : null
  description = "RDS endpoint (null when RDS disabled)."
}

