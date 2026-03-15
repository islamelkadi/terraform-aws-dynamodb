## [1.1.0](https://github.com/islamelkadi/terraform-aws-dynamodb/compare/v1.0.2...v1.1.0) (2026-03-15)


### Features

* add manual triggering to release workflow ([23a0284](https://github.com/islamelkadi/terraform-aws-dynamodb/commit/23a0284f2108e448830f4f696b5c78eae407f81c))


### Documentation

* add GitHub Actions workflow status badges ([8c13a40](https://github.com/islamelkadi/terraform-aws-dynamodb/commit/8c13a4082e2171965340f8290fe08789d5475d86))
* add security scan suppressions section to README ([aaadf8b](https://github.com/islamelkadi/terraform-aws-dynamodb/commit/aaadf8b0b5b5c95f45ee5f7c14e94bd8de847cc2))

## [1.0.2](https://github.com/islamelkadi/terraform-aws-dynamodb/compare/v1.0.1...v1.0.2) (2026-03-08)


### Bug Fixes

* add CKV_TF_1 suppression for external module metadata ([8e4489d](https://github.com/islamelkadi/terraform-aws-dynamodb/commit/8e4489d7f4d52fbfde35540b6f58c7e1965c3cf1))
* add skip-path for .external_modules in Checkov config ([5f59cc2](https://github.com/islamelkadi/terraform-aws-dynamodb/commit/5f59cc26494ec1296ece9f396d6f12499dd4262d))
* address Checkov security findings ([307e097](https://github.com/islamelkadi/terraform-aws-dynamodb/commit/307e09773a4759df8e13354295e4ce758aafb568))
* correct .checkov.yaml format to use simple list instead of id/comment dict ([3f7906b](https://github.com/islamelkadi/terraform-aws-dynamodb/commit/3f7906b5570151cceda1374d79637c68fa9c8ff1))
* remove skip-path from .checkov.yaml, rely on workflow-level skip_path ([6b4b463](https://github.com/islamelkadi/terraform-aws-dynamodb/commit/6b4b463cdfd88d57ea8f01f117698e9d754ceb92))
* update workflow path reference to terraform-security.yaml ([ddac5dd](https://github.com/islamelkadi/terraform-aws-dynamodb/commit/ddac5dda4f99d296accb62881f998e0ba9037d91))

## [1.0.1](https://github.com/islamelkadi/terraform-aws-dynamodb/compare/v1.0.0...v1.0.1) (2026-03-08)


### Code Refactoring

* enhance examples with real infrastructure and improve code quality ([43624c7](https://github.com/islamelkadi/terraform-aws-dynamodb/commit/43624c735bb942f2eaaca1bc068f0e37a62ab2b1))

## 1.0.0 (2026-03-07)


### ⚠ BREAKING CHANGES

* First publish - DynamoDB Terraform module

### Features

* First publish - DynamoDB Terraform module ([48f720e](https://github.com/islamelkadi/terraform-aws-dynamodb/commit/48f720ee86ed4f9433cdabd827973329f2d690b7))
