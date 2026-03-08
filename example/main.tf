# Primary Module Example - This demonstrates the terraform-aws-dynamodb module
# Supporting infrastructure (KMS) is defined in separate files
# to keep this example focused on the module's core functionality.
#
# DynamoDB Module Example
# Demonstrates table creation with GSI, TTL, and streams

module "dynamodb_table" {
  source = "../"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  region      = var.region

  # Composite key
  hash_key  = var.hash_key
  range_key = var.range_key

  # Attributes
  attributes = var.attributes

  # Global Secondary Indexes
  global_secondary_indexes = var.global_secondary_indexes

  # TTL configuration
  ttl_enabled        = var.ttl_enabled
  ttl_attribute_name = var.ttl_attribute_name

  # Streams configuration
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type

  # Recovery and protection
  enable_point_in_time_recovery = var.enable_point_in_time_recovery
  deletion_protection_enabled   = var.deletion_protection_enabled

  # Direct reference to kms.tf module output
  kms_key_arn = module.kms_key.key_arn

  tags = var.tags
}
