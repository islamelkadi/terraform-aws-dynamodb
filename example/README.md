# DynamoDB Module Example

This example demonstrates how to use the DynamoDB module with global secondary indexes, TTL, and streams.

## Features Demonstrated

- Composite primary key (hash + range)
- Global Secondary Indexes (GSI)
- Time-to-Live (TTL) configuration
- DynamoDB Streams
- Point-in-time recovery
- KMS encryption

## Usage

1. Update `params/input.tfvars` with your values:
   - Replace `kms_key_arn` with your KMS key ARN
   - Adjust table schema (attributes, keys, indexes) as needed
   - Modify TTL and streams settings

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Plan the deployment:
   ```bash
   terraform plan -var-file=params/input.tfvars
   ```

4. Apply the configuration:
   ```bash
   terraform apply -var-file=params/input.tfvars
   ```

## Table Schema

The example creates a table with:

- **Primary Key**: 
  - Hash Key: `event_id` (String)
  - Range Key: `customer_id` (String)

- **Global Secondary Indexes**:
  - `customer_id-index`: Query by customer (ALL projection)
  - `security_id-index`: Query by security (KEYS_ONLY projection)

- **TTL**: Enabled on `ttl` attribute

- **Streams**: Enabled with NEW_AND_OLD_IMAGES view type

## Prerequisites

- AWS KMS key for encryption
- Appropriate IAM permissions to create DynamoDB tables

## Outputs

- `table_id` - ID of the DynamoDB table
- `table_arn` - ARN of the DynamoDB table
- `table_name` - Name of the DynamoDB table
- `stream_arn` - ARN of the DynamoDB stream (if enabled)
