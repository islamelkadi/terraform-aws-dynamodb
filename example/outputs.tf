# Complete Example Outputs

output "table_name" {
  description = "Name of the DynamoDB table"
  value       = module.dynamodb_table.table_name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.dynamodb_table.table_arn
}

output "stream_arn" {
  description = "ARN of the DynamoDB stream"
  value       = module.dynamodb_table.stream_arn
}

output "hash_key" {
  description = "Hash key attribute name"
  value       = module.dynamodb_table.hash_key
}

output "range_key" {
  description = "Range key attribute name"
  value       = module.dynamodb_table.range_key
}
