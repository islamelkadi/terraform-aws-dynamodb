# DynamoDB Module Example Input Variables

namespace   = "example"
environment = "dev"
name        = "affected-positions"
region      = "us-east-1"

# Composite key
hash_key  = "event_id"
range_key = "customer_id"

# Define all attributes used in keys and indexes
attributes = [
  {
    name = "event_id"
    type = "S"
  },
  {
    name = "customer_id"
    type = "S"
  },
  {
    name = "security_id"
    type = "S"
  }
]

# Global Secondary Indexes
global_secondary_indexes = [
  {
    name            = "customer_id-index"
    hash_key        = "customer_id"
    projection_type = "ALL"
  },
  {
    name            = "security_id-index"
    hash_key        = "security_id"
    projection_type = "KEYS_ONLY"
  }
]

# TTL configuration
ttl_enabled        = true
ttl_attribute_name = "ttl"

# Streams configuration
stream_enabled   = true
stream_view_type = "NEW_AND_OLD_IMAGES"

# Recovery and protection
enable_point_in_time_recovery = true
deletion_protection_enabled   = false

# KMS key ARN for encryption (replace with your KMS key ARN)
kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

tags = {
  Example     = "DYNAMODB_TABLE"
  Application = "CORPORATE_ACTIONS"
  Team        = "OPERATIONS"
}
