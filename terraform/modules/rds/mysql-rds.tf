
resource "aws_db_subnet_group" "umami_db_subnet_group" {
  name       = "umami-db-subnets"
  subnet_ids = var.private_rds

  tags = {
    Name = "umami-db-subnets"
  }
}

# RDS INSTANCE CONFIGURATION BLOCK
resource "aws_db_instance" "umami_rds" {
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

  parameter_group_name = aws_db_parameter_group.umami_pg.name

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
