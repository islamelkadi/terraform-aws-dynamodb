# Local values for naming and tagging

locals {
  # Construct table name from components
  name_parts = compact(concat(
    [var.namespace],
    [var.environment],
    [var.name],
    var.naming_attributes
  ))

  table_name = join(var.delimiter, local.name_parts)

  # Merge tags with defaults
  tags = merge(
    var.tags,
    module.metadata.security_tags,
    {
      Name   = local.table_name
      Module = "terraform-aws-dynamodb"
    }
  )
}
