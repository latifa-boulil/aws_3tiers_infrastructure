output "rds_endpoint" {
    description = "RDS Endpoint for Database Connection"
    value = aws_db_instance.database.endpoint
}

output "rds_arn" {
    description = "Retrieve Database ARN"
    value = aws_db_instance.database.arn 
}

