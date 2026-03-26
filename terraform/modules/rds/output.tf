
# RDS ENDPOINT OUTPUT VARIABLE
output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.umami_rds.address
}

# RDS PORT OUTPUT VARIABLE
output "rds_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.umami_rds.port
}

# RDS DB OUTPUT VARIABLE
output "rds_db_name" {
  description = "The database name"
  value       = aws_db_instance.umami_rds.db_name
}

# RDS DB NAME 
output "rds_id" {
  description = " rds db identifier" 
  value       = aws_db_instance.umami_rds.id
}


