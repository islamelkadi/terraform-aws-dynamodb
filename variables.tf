# DynamoDB Table Module Variables

# Metadata variables for consistent naming
variable "namespace" {
  description = "Namespace (organization/team name)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "naming_attributes" {
  description = "Additional attributes for naming"
  type        = list(string)
  default     = []
}

variable "delimiter" {
  description = "Delimiter to use between name components"
  type        = string
  default     = "-"
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

# DynamoDB specific variables
variable "hash_key" {
  description = "Attribute to use as the hash (partition) key"
  type        = string
}

variable "range_key" {
  description = "Attribute to use as the range (sort) key. Optional"
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of attribute definitions. Each attribute must have 'name' and 'type' (S, N, or B)"
  type = list(object({
    name = string
    type = string
  }))

  validation {
    condition = alltrue([
      for attr in var.attributes : contains(["S", "N", "B"], attr.type)
    ])
    error_message = "Attribute type must be S (string), N (number), or B (binary)"
  }
}

variable "kms_key_arn" {
  description = "ARN of KMS key for table encryption"
  type        = string
}

variable "enable_point_in_time_recovery" {
  description = "Enable point-in-time recovery for the table"
  type        = bool
  default     = true
}

variable "ttl_enabled" {
  description = "Enable TTL for the table"
  type        = bool
  default     = true
}

variable "ttl_attribute_name" {
  description = "Name of the table attribute to use for TTL. Set to null to disable TTL"
  type        = string
  default     = "ttl"
}

variable "global_secondary_indexes" {
  description = "List of global secondary index configurations"
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    projection_type    = optional(string)
    non_key_attributes = optional(list(string))
  }))
  default = []
}

variable "local_secondary_indexes" {
  description = "List of local secondary index configurations"
  type = list(object({
    name               = string
    range_key          = string
    projection_type    = optional(string)
    non_key_attributes = optional(list(string))
  }))
  default = []
}

variable "stream_enabled" {
  description = "Enable DynamoDB Streams"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Stream view type (KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES)"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"

  validation {
    condition     = contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.stream_view_type)
    error_message = "Stream view type must be KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, or NEW_AND_OLD_IMAGES"
  }
}

variable "deletion_protection_enabled" {
  description = "Enable deletion protection for the table"
  type        = bool
  default     = false
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}

# Security controls
variable "security_controls" {
  description = "Security controls configuration from metadata module"
  type = object({
    encryption = object({
      require_kms_customer_managed  = bool
      require_encryption_at_rest    = bool
      require_encryption_in_transit = bool
      enable_kms_key_rotation       = bool
    })
    logging = object({
      require_cloudwatch_logs = bool
      min_log_retention_days  = number
      require_access_logging  = bool
      require_flow_logs       = bool
    })
    monitoring = object({
      enable_xray_tracing         = bool
      enable_enhanced_monitoring  = bool
      enable_performance_insights = bool
      require_cloudtrail          = bool
    })
    network = object({
      require_private_subnets = bool
      require_vpc_endpoints   = bool
      block_public_ingress    = bool
      require_imdsv2          = bool
    })
    compliance = object({
      enable_point_in_time_recovery = bool
      require_reserved_concurrency  = bool
      enable_deletion_protection    = bool
    })
    data_protection = object({
      require_versioning         = bool
      require_mfa_delete         = bool
      require_automated_backups  = bool
      block_public_access        = bool
      require_lifecycle_policies = bool
    })
  })
  default = null
}

variable "security_control_overrides" {
  description = "Override specific security controls with documented justification"
  type = object({
    disable_kms_requirement     = optional(bool, false)
    disable_pitr_requirement    = optional(bool, false)
    disable_deletion_protection = optional(bool, false)
    justification               = optional(string, "")
  })
  default = {
    disable_kms_requirement     = false
    disable_pitr_requirement    = false
    disable_deletion_protection = false
    justification               = ""
  }
}
