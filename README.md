# Terraform AWS DynamoDB Module

A reusable Terraform module for creating AWS DynamoDB tables with AWS Security Hub compliance (FSBP, CIS, NIST 800-53, NIST 800-171, PCI DSS), flexible security control overrides, and comprehensive configuration options.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Security](#security)
- [Features](#features)
- [Usage](#usage)
- [Requirements](#requirements)
- [MCP Servers](#mcp-servers)


## Prerequisites

This module is designed for macOS. The following must already be installed on your machine:
- Python 3 and pip
- [Kiro](https://kiro.dev) and Kiro CLI
- [Homebrew](https://brew.sh)

To install the remaining development tools, run:

```bash
make bootstrap
```

This will install/upgrade: tfenv, Terraform (via tfenv), tflint, terraform-docs, checkov, and pre-commit.



## Security

### Security Controls

This module implements AWS Security Hub compliance with an extensible override system. Security controls are enforced by default when `security_controls` is provided from the metadata module.

### Available Security Control Overrides

| Override Flag | Description | Common Justification |
|--------------|-------------|---------------------|
| `disable_kms_requirement` | Allows AWS-managed encryption | "Development table, no sensitive data" |
| `disable_pitr_requirement` | Disables point-in-time recovery | "Ephemeral data, disposable table" |
| `disable_deletion_protection` | Allows table deletion | "Development table, easy teardown needed" |

### Security Best Practices

**Production Tables:**
- Use KMS customer-managed keys for encryption
- Enable point-in-time recovery (PITR) for data protection
- Enable deletion protection to prevent accidental deletion
- Use on-demand billing or provisioned with auto-scaling
- Enable DynamoDB Streams for change data capture
- Set up CloudWatch alarms for throttling and errors

**Development Tables:**
- KMS encryption still recommended (minimal cost)
- PITR optional for cost savings
- Deletion protection can be disabled with justification

### Environment-Based Security Controls

Security controls are automatically applied based on the environment through the [terraform-aws-metadata](https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles){:target="_blank"} module's security profiles:

| Control | Dev | Staging | Prod |
|---------|-----|---------|------|
| KMS customer-managed keys | Optional | Required | Required |
| Point-in-time recovery | Optional | Required | Required |
| Deletion protection | Disabled | Enabled | Enabled |
| DynamoDB Streams | Optional | Recommended | Recommended |

For full details on security profiles and how controls vary by environment, see the <a href="https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles" target="_blank">Security Profiles</a> documentation.

### Security Best Practices

**Production Tables:**
- Use KMS customer-managed keys for encryption
- Enable point-in-time recovery (PITR) for data protection
- Enable deletion protection to prevent accidental deletion
- Use on-demand billing or provisioned with auto-scaling
- Enable DynamoDB Streams for change data capture
- Set up CloudWatch alarms for throttling and errors

**Development Tables:**
- KMS encryption still recommended (minimal cost)
- PITR optional for cost savings
- Deletion protection can be disabled with justification
## Features

- DynamoDB table with on-demand billing mode
- KMS encryption with customer-managed keys
- Point-in-time recovery (PITR) for data protection
- Deletion protection option
- DynamoDB Streams support
- TTL (Time To Live) configuration
- Global and local secondary indexes
- Security controls integration with extensible override system
- Terraform validation checks for compliance

## Usage Examples

### Basic Example

```hcl
module "dynamodb_table" {
  source = "github.com/islamelkadi/terraform-aws-dynamodb?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "events"
  region      = "us-east-1"
  
  # Table schema
  hash_key = "event_id"
  range_key = "timestamp"
  
  attributes = [
    {
      name = "event_id"
      type = "S"
    },
    {
      name = "timestamp"
      type = "N"
    }
  ]
  
  # Encryption
  kms_key_arn = module.kms.key_arn
  
  tags = {
    Project = "CorporateActions"
  }
}
```

### Production Table with Security Controls

```hcl
module "dynamodb_table" {
  source = "github.com/islamelkadi/terraform-aws-dynamodb?ref=v1.0.0"
  
  # Pass security controls from metadata module
  security_controls = module.metadata.security_controls
  
  namespace   = "example"
  environment = "prod"
  name        = "corporate-actions-events"
  region      = "us-east-1"
  
  # Table schema
  hash_key  = "event_id"
  range_key = "timestamp"
  
  attributes = [
    {
      name = "event_id"
      type = "S"
    },
    {
      name = "timestamp"
      type = "N"
    },
    {
      name = "cusip"
      type = "S"
    }
  ]
  
  # Global secondary index
  global_secondary_indexes = [
    {
      name            = "cusip-timestamp-index"
      hash_key        = "cusip"
      range_key       = "timestamp"
      projection_type = "ALL"
    }
  ]
  
  # KMS encryption (required by security controls)
  kms_key_arn = module.kms.key_arn
  
  # Point-in-time recovery (required by security controls)
  enable_point_in_time_recovery = true
  
  # Deletion protection (required by security controls)
  deletion_protection_enabled = true
  
  # DynamoDB Streams for change data capture
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  
  # TTL for automatic data expiration
  ttl_enabled        = true
  ttl_attribute_name = "expires_at"
  
  tags = {
    Project     = "CorporateActions"
    Compliance  = "PCI-DSS"
    DataClass   = "Confidential"
  }
}
```

### Development Table with Overrides

```hcl
module "dynamodb_table" {
  source = "github.com/islamelkadi/terraform-aws-dynamodb?ref=v1.0.0"
  
  security_controls = module.metadata.security_controls
  
  # Override security controls for development
  security_control_overrides = {
    disable_pitr_requirement    = true
    disable_deletion_protection = true
    justification = "Development table for testing. Data is disposable and recreated from seed scripts. PITR adds unnecessary cost. Deletion protection disabled for easy environment teardown."
  }
  
  namespace   = "example"
  environment = "dev"
  name        = "test-events"
  region      = "us-east-1"
  
  hash_key = "id"
  
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
  
  # Still use KMS encryption
  kms_key_arn = module.kms.key_arn
  
  # Overrides allow these to be disabled
  enable_point_in_time_recovery = false
  deletion_protection_enabled    = false
  
  tags = {
    Project     = "CorporateActions"
    Environment = "Development"
  }
}
```

### Table with Streams for Event Processing

```hcl
module "events_table" {
  source = "github.com/islamelkadi/terraform-aws-dynamodb?ref=v1.0.0"
  
  security_controls = module.metadata.security_controls
  
  namespace   = "example"
  environment = "prod"
  name        = "events"
  region      = "us-east-1"
  
  hash_key  = "event_id"
  range_key = "timestamp"
  
  attributes = [
    {
      name = "event_id"
      type = "S"
    },
    {
      name = "timestamp"
      type = "N"
    }
  ]
  
  kms_key_arn                    = module.kms.key_arn
  enable_point_in_time_recovery  = true
  deletion_protection_enabled    = true
  
  # Enable streams for Lambda processing
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  
  tags = {
    Project = "CorporateActions"
    Purpose = "EventSourcing"
  }
}

# Lambda to process DynamoDB stream
module "stream_processor" {
  source = "github.com/islamelkadi/terraform-aws-lambda?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "events-stream-processor"
  region      = "us-east-1"
  
  runtime = "python3.13"
  handler = "index.handler"
  filename = "processor.zip"
  
  # Grant Lambda permission to read from stream
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
  ]
}

# Event source mapping
resource "aws_lambda_event_source_mapping" "dynamodb_stream" {
  event_source_arn  = module.events_table.stream_arn
  function_name     = module.stream_processor.function_name
  starting_position = "LATEST"
  
  batch_size = 100
  maximum_batching_window_in_seconds = 5
}
```


## MCP Servers

This module includes two [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) servers configured in `.kiro/settings/mcp.json` for use with Kiro:

| Server | Package | Description |
|--------|---------|-------------|
| `aws-docs` | `awslabs.aws-documentation-mcp-server@latest` | Provides access to AWS documentation for contextual lookups of service features, API references, and best practices. |
| `terraform` | `awslabs.terraform-mcp-server@latest` | Enables Terraform operations (init, validate, plan, fmt, tflint) directly from the IDE with auto-approved commands for common workflows. |

Both servers run via `uvx` and require no additional installation beyond the [bootstrap](#prerequisites) step.

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
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

  # Encryption
  kms_key_arn = var.kms_key_arn

  tags = var.tags
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.34 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.34 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_metadata"></a> [metadata](#module\_metadata) | github.com/islamelkadi/terraform-aws-metadata | v1.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | List of attribute definitions. Each attribute must have 'name' and 'type' (S, N, or B) | <pre>list(object({<br/>    name = string<br/>    type = string<br/>  }))</pre> | n/a | yes |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enable deletion protection for the table | `bool` | `false` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to use between name components | `string` | `"-"` | no |
| <a name="input_enable_point_in_time_recovery"></a> [enable\_point\_in\_time\_recovery](#input\_enable\_point\_in\_time\_recovery) | Enable point-in-time recovery for the table | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, staging, prod) | `string` | n/a | yes |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | List of global secondary index configurations | <pre>list(object({<br/>    name               = string<br/>    hash_key           = string<br/>    range_key          = optional(string)<br/>    projection_type    = optional(string)<br/>    non_key_attributes = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Attribute to use as the hash (partition) key | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of KMS key for table encryption | `string` | n/a | yes |
| <a name="input_local_secondary_indexes"></a> [local\_secondary\_indexes](#input\_local\_secondary\_indexes) | List of local secondary index configurations | <pre>list(object({<br/>    name               = string<br/>    range_key          = string<br/>    projection_type    = optional(string)<br/>    non_key_attributes = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the DynamoDB table | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace (organization/team name) | `string` | n/a | yes |
| <a name="input_naming_attributes"></a> [naming\_attributes](#input\_naming\_attributes) | Additional attributes for naming | `list(string)` | `[]` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | Attribute to use as the range (sort) key. Optional | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_security_control_overrides"></a> [security\_control\_overrides](#input\_security\_control\_overrides) | Override specific security controls with documented justification | <pre>object({<br/>    disable_kms_requirement     = optional(bool, false)<br/>    disable_pitr_requirement    = optional(bool, false)<br/>    disable_deletion_protection = optional(bool, false)<br/>    justification               = optional(string, "")<br/>  })</pre> | <pre>{<br/>  "disable_deletion_protection": false,<br/>  "disable_kms_requirement": false,<br/>  "disable_pitr_requirement": false,<br/>  "justification": ""<br/>}</pre> | no |
| <a name="input_security_controls"></a> [security\_controls](#input\_security\_controls) | Security controls configuration from metadata module | <pre>object({<br/>    encryption = object({<br/>      require_kms_customer_managed  = bool<br/>      require_encryption_at_rest    = bool<br/>      require_encryption_in_transit = bool<br/>      enable_kms_key_rotation       = bool<br/>    })<br/>    logging = object({<br/>      require_cloudwatch_logs = bool<br/>      min_log_retention_days  = number<br/>      require_access_logging  = bool<br/>      require_flow_logs       = bool<br/>    })<br/>    monitoring = object({<br/>      enable_xray_tracing         = bool<br/>      enable_enhanced_monitoring  = bool<br/>      enable_performance_insights = bool<br/>      require_cloudtrail          = bool<br/>    })<br/>    network = object({<br/>      require_private_subnets = bool<br/>      require_vpc_endpoints   = bool<br/>      block_public_ingress    = bool<br/>      require_imdsv2          = bool<br/>    })<br/>    compliance = object({<br/>      enable_point_in_time_recovery = bool<br/>      require_reserved_concurrency  = bool<br/>      enable_deletion_protection    = bool<br/>    })<br/>    data_protection = object({<br/>      require_versioning         = bool<br/>      require_mfa_delete         = bool<br/>      require_automated_backups  = bool<br/>      block_public_access        = bool<br/>      require_lifecycle_policies = bool<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | Enable DynamoDB Streams | `bool` | `false` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | Stream view type (KEYS\_ONLY, NEW\_IMAGE, OLD\_IMAGE, NEW\_AND\_OLD\_IMAGES) | `string` | `"NEW_AND_OLD_IMAGES"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_ttl_attribute_name"></a> [ttl\_attribute\_name](#input\_ttl\_attribute\_name) | Name of the table attribute to use for TTL. Set to null to disable TTL | `string` | `"ttl"` | no |
| <a name="input_ttl_enabled"></a> [ttl\_enabled](#input\_ttl\_enabled) | Enable TTL for the table | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hash_key"></a> [hash\_key](#output\_hash\_key) | Hash key attribute name |
| <a name="output_range_key"></a> [range\_key](#output\_range\_key) | Range key attribute name |
| <a name="output_stream_arn"></a> [stream\_arn](#output\_stream\_arn) | DynamoDB table stream ARN |
| <a name="output_stream_label"></a> [stream\_label](#output\_stream\_label) | DynamoDB table stream label |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | DynamoDB table ARN |
| <a name="output_table_id"></a> [table\_id](#output\_table\_id) | DynamoDB table ID (same as table name) |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | DynamoDB table name |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags applied to the DynamoDB table |


## Examples

See [example/](example/) for a complete working example with GSI, TTL, and streams.

