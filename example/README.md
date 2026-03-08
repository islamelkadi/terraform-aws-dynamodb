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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.34 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb_table"></a> [dynamodb\_table](#module\_dynamodb\_table) | ../ | n/a |
| <a name="module_kms_key"></a> [kms\_key](#module\_kms\_key) | git::https://github.com/islamelkadi/terraform-aws-kms.git | v1.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | List of attribute definitions | <pre>list(object({<br/>    name = string<br/>    type = string<br/>  }))</pre> | n/a | yes |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enable deletion protection | `bool` | `false` | no |
| <a name="input_enable_point_in_time_recovery"></a> [enable\_point\_in\_time\_recovery](#input\_enable\_point\_in\_time\_recovery) | Enable point-in-time recovery | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, staging, prod) | `string` | n/a | yes |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | List of global secondary index configurations | <pre>list(object({<br/>    name               = string<br/>    hash_key           = string<br/>    range_key          = optional(string)<br/>    projection_type    = optional(string)<br/>    non_key_attributes = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Attribute to use as the hash (partition) key | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the DynamoDB table | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace (organization/team name) | `string` | n/a | yes |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | Attribute to use as the range (sort) key | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | Enable DynamoDB Streams | `bool` | `false` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | Stream view type | `string` | `"NEW_AND_OLD_IMAGES"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags | `map(string)` | `{}` | no |
| <a name="input_ttl_attribute_name"></a> [ttl\_attribute\_name](#input\_ttl\_attribute\_name) | Name of the table attribute to use for TTL | `string` | `"ttl"` | no |
| <a name="input_ttl_enabled"></a> [ttl\_enabled](#input\_ttl\_enabled) | Enable TTL for the table | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hash_key"></a> [hash\_key](#output\_hash\_key) | Hash key attribute name |
| <a name="output_range_key"></a> [range\_key](#output\_range\_key) | Range key attribute name |
| <a name="output_stream_arn"></a> [stream\_arn](#output\_stream\_arn) | ARN of the DynamoDB stream |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | Name of the DynamoDB table |
<!-- END_TF_DOCS -->
