
resource "aws_db_subnet_group" "umami_db_subnet_group" {
  name       = "umami-db-subnets"
  subnet_ids = var.private_rds

  tags = {
    Name = "umami-db-subnets"
  }
}
# DB CREDENTIALS
resource "aws_secretsmanager_secret" "db" {
  name = "umami-db-credentials"
}
data "aws_secretsmanager_secret" "db" {
  name = aws_secretsmanager_secret.db.name
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = data.aws_secretsmanager_secret.db.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}



# RDS INSTANCE CONFIGURATION BLOCK
resource "aws_db_instance" "umami_rds" {
  username = local.db_creds.username
  password = local.db_creds.password
  identifier              = "umami-db"
  engine                  = "postgres"
  engine_version          = "15.13"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = "umami"
  db_subnet_group_name    = aws_db_subnet_group.umami_db_subnet_group.name
  vpc_security_group_ids  = [var.rds_sg]
  publicly_accessible     = false
  deletion_protection     = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "umami-final-snapshot"


# RDS BACK-UP ARGUEMENT INCLUDED WITH RETENTION PERIOD
  maintenance_window      = "Fri:09:00-Fri:09:30"
  backup_retention_period = 7

# CLOUD WATCH ENABLED FOR OBSERVERBILITY
  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade"
  ]

  tags = {
    Name = "umami-rds"
  }
}


# RDS SNAPSHOT
resource "aws_db_snapshot" "db_snapshot" {
  db_instance_identifier  = aws_db_instance.umami_rds.id
  db_snapshot_identifier  = "umami-snapshot-20251215"

}
