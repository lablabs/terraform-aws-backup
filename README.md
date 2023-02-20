# AWS Backup Terraform module

[<img src="https://lablabs.io/static/ll-logo.png" width=350px>](https://lablabs.io/)

We help companies build, run, deploy and scale software and infrastructure by embracing the right technologies and principles. Check out our website at <https://lablabs.io/>

---

[![Terraform validate](https://github.com/lablabs/terraform-aws-backup/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-backup/actions/workflows/validate.yaml)
[![pre-commit](https://github.com/lablabs/terraform-aws-backup/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/lablabs/terraform-aws-backup/actions/workflows/pre-commit.yml)

## Description

A Terraform module to provision AWS Backup

## Related Projects

Check out other [terraform modules](https://github.com/orgs/lablabs/repositories?q=terraform-aws&type=public&language=&sort=).

## Examples
- [Single account example](examples/single-account/README.md)
- [Cross account example](examples/cross-account/README.md)
  - Backup vault in other account will be created

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.19.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_source_kms_key"></a> [source\_kms\_key](#module\_source\_kms\_key) | cloudposse/kms-key/aws | 0.12.1 |
| <a name="module_source_label"></a> [source\_label](#module\_source\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_source_role"></a> [source\_role](#module\_source\_role) | cloudposse/iam-role/aws | 0.17.0 |
| <a name="module_target_kms_key"></a> [target\_kms\_key](#module\_target\_kms\_key) | cloudposse/kms-key/aws | 0.12.1 |
| <a name="module_target_label"></a> [target\_label](#module\_target\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_target_role"></a> [target\_role](#module\_target\_role) | cloudposse/iam-role/aws | 0.17.0 |

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.tag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_policy.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_backup_vault_policy.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_caller_identity.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_source_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_target_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.source_vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.target_vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_backup_plans"></a> [backup\_plans](#input\_backup\_plans) | Backup plans config along with rule and resources setup | <pre>list(object({<br>    name      = string<br>    resources = optional(list(string), [])<br>    selection_tags = optional(list(object({<br>      type  = string<br>      key   = string<br>      value = string<br>    })), [])<br>    rules = list(object({<br>      name                     = string<br>      schedule                 = string<br>      enable_continuous_backup = optional(bool)<br>      start_window             = optional(string, 60)<br>      completion_window        = optional(number, 180)<br>      lifecycle = optional(object({<br>        cold_storage_after = optional(number)<br>        delete_after       = optional(number)<br>      }))<br>      copy_action_lifecycle = optional(object({<br>        cold_storage_after = optional(number)<br>        delete_after       = optional(number)<br>      }))<br>      recovery_point_tags = optional(map(string))<br>    }))<br>    advanced_backup_setting = optional(object({<br>      WindowsVSS    = optional(string, null)<br>      resource_type = optional(string, null)<br>    }), null)<br>  }))</pre> | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Variable indicating whether deployment is enabled | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_is_cross_account_backup_enabled"></a> [is\_cross\_account\_backup\_enabled](#input\_is\_cross\_account\_backup\_enabled) | Create backup vault on different account and turn on copy action to this vault (provider.target needs to be set) | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_source_backup_vault_arn"></a> [source\_backup\_vault\_arn](#output\_source\_backup\_vault\_arn) | Backup Vault ARN of source backup vault |
| <a name="output_source_backup_vault_id"></a> [source\_backup\_vault\_id](#output\_source\_backup\_vault\_id) | Backup Vault ID of source backup vault |
| <a name="output_target_backup_vault_arn"></a> [target\_backup\_vault\_arn](#output\_target\_backup\_vault\_arn) | Backup Vault ARN of target backup vault |
| <a name="output_target_backup_vault_id"></a> [target\_backup\_vault\_id](#output\_target\_backup\_vault\_id) | Backup Vault ID of target backup vault |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing and reporting issues

Feel free to create an issue in this repository if you have questions, suggestions or feature requests.

### Validation, linters and pull-requests

We want to provide high quality code and modules. For this reason we are using
several [pre-commit hooks](.pre-commit-config.yaml) and
[GitHub Actions workflows](.github/workflows/). A pull-request to the
main branch will trigger these validations and lints automatically. Please
check your code before you will create pull-requests. See
[pre-commit documentation](https://pre-commit.com/) and
[GitHub Actions documentation](https://docs.github.com/en/actions) for further
details.

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.
