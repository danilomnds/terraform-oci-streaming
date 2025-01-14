# Module - Oracle Streaming Service
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()
[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![OCI](https://img.shields.io/badge/provider-OCI-red)](https://registry.terraform.io/providers/oracle/oci/latest)

Module developed to standardize the creation of Oracle Streaming Service.

## Compatibility Matrix

| Module Version | Terraform Version | OCI Version     |
|----------------|-------------------| --------------- |
| v1.0.0         | v1.10.2           | 6.21.0          |

## Specifying a version

To avoid that your code get the latest module version, you can define the `?ref=***` in the URL to point to a specific version.
Note: The `?ref=***` refers a tag on the git module repo.

## Default use case
```hcl
module "ssx-system-env-id" {    
  source = "git::https://github.com/danilomnds/terraform-oci-streaming?ref=v1.1.0"
  compartment_id = <compartment id>
  name = <ssx-system-env-id>
  kafka_settings = {
    log_retention_hours = 24
    num_partitions = 1
  }
  private_endpoint_settings = {
    subnet_id = <oci subnet id>
  }
  stream = [{
    name = stream1
    partitions = 1
    retention_in_hours = 24
  },
  {
    name = stream2
    partitions = 1
    retention_in_hours = 24
  }
  ]
  defined_tags = {
    "IT.area":"infrastructure"
    "IT.department":"ti"    
  }
}
output "stream_pool_id" {
  value = module.ssx-system-env-id.stream_pool_id
}
output "stream_id" {
  value = module.ssx-system-env-id.stream_id
}
```

## Default use case plus RBAC
```hcl
module "ssx-system-env-id" {    
  source = "git::https://github.com/danilomnds/terraform-oci-streaming?ref=v1.0.0"
  compartment_id = <compartment id>
  name = <ssx-system-env-id>
  kafka_settings = {
    log_retention_hours = 24
    num_partitions = 1
  }
  private_endpoint_settings = {
    subnet_id = <oci subnet id>
  }
  stream = [{
    name = stream1
    partitions = 1
    retention_in_hours = 24
  },
  {
    name = stream2
    partitions = 1
    retention_in_hours = 24
  }
  ]
  # GRP_OCI_APP-ENV is the Azure AD group that you are going to grant the permissions
  groups = ["OracleIdentityCloudService/GRP_OCI_APP-ENV", "group name 2"]
  # service account
  service_account_name        = "sa-timsa-it-streaming-system-end"
  service_account_description = "A conta de serviço do projeto solicitada via chamado XXXXXXXX. Integração do streaming com demais serviços"
  root_compartment_id         = "id"
  group_name                  = "OCI_STREAM-system-env"
  group_description           = "Grupo para usuário p/ a service account de streaming"
  defined_tags = {
    "IT.area":"infrastructure"
    "IT.department":"ti"    
  }
}
output "stream_pool_id" {
  value = module.ssx-system-env-id.stream_pool_id
}
output "stream_id" {
  value = module.ssx-system-env-id.stream_id
}
```

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment_id | the ocid of the compartment | `string` | n/a | `Yes` |
| custom_encryption_key | The OCID of the custom encryption key to be used or deleted if currently being used | `object({})` | n/a | No |
| defined_tags | Defined tags for this resource | `map(string)` | n/a | No |
| freeform_tags | Free-form tags for this resource | `map(string)` | n/a | No |
| kafka_settings | Settings for the Kafka compatibility layer | `object({})` | n/a | No |
| name | The name of the stream | `string` | n/a | `Yes` |
| private_endpoint_settings | Optional parameters if a private stream pool is requested | `object({})` | n/a | No |
| stream | List of stream that will be creating using the stream pool created by this module | `object({})` | n/a | No |
| groups | list of groups that will access the resource | `list(string)` | n/a | No |
| root_compartment_id | The OCID of the root compartment where the service account will be created | `string` | n/a | `Yes if you need a SA` |
| service_account_description | The description you assign to the user during creation | `string` | n/a | `Yes if you need a SA` |
| service_account_name | the name of the service account | `string` | n/a | `Yes if you need a SA` |
| group_name | the group name that the sa will belong to | `string` | n/a | `Yes if you need a SA` |
| group_description | The group description | `string` | n/a | `Yes if you need a SA` |


# Object variables for blocks Stream Pool

| Variable Name (Block) | Parameter | Description | Type | Default | Required |
|-----------------------|-----------|-------------|------|---------|:--------:|
| custom_encryption_key | kms_key_id | Custom Encryption Key (Master Key) ocid  | `string` | n/a | `Yes` |
| kafka_settings | optional (auto_create_topics_enable) |  Enable auto creation of topic on the server | `bool` | n/a | No |
| kafka_settings | optional (bootstrap_servers) |Bootstrap servers  | `string` | n/a | No |
| kafka_settings | optional (log_retention_hours) | The number of hours to keep a log file before deleting it (in hours) | `number` | n/a | No |
| kafka_settings | optional (num_partitions) | The default number of log partitions per topic | `number` | n/a | No |
| private_endpoint_settings | optional (nsg_ids) | The optional list of network security groups to be used with the private endpoint of the stream pool | `list(string)` | n/a | No |
| private_endpoint_settings | optional (private_endpoint_ip) | The optional private IP you want to be associated with your private stream pool | `list(string)` | n/a | No |
| private_endpoint_settings | optional (subnet_id) | If specified, the stream pool will be private and only accessible from inside that subnet | `string ` | n/a | No |


# Object variables for blocks Stream

| Variable Name (Block) | Parameter | Description | Type | Default | Required |
|-----------------------|-----------|-------------|------|---------|:--------:|
| stream | name | The name of the stream  | `string` | n/a | `Yes` |
| stream | partitions | The number of partitions in the stream  | `number` | n/a | `Yes` |
| stream | retention_in_hours | The retention period of the stream, in hours. Accepted values are between 24 and 168 (7 days)  | `number` | `24` | No |


## Output variables

| Name | Description |
|------|-------------|
| stream_pool_id | stream pool id|
| stream_id | stream(s) id |

## Documentation
Oracle Streaming Service: <br>
[https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/database_autonomous_container_database](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/streaming_stream_pool)
[https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/streaming_stream](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/streaming_stream)