output "rds_endpoint" {
    description = "rds endpoint for database connection"
    value = aws_db_instance.database.endpoint
}

output "rds_arn" {
    description = "retrieve the arn of our database"
    value = aws_db_instance.database.arn
  
}