variable "compartment_id" {
  type = string
}

variable "custom_encryption_key" {
  type = object({
    kms_key_id = string
  })
  default = null
}

variable "defined_tags" {
  type    = map(string)
  default = null
}

variable "freeform_tags" {
  type    = map(string)
  default = null
}

variable "kafka_settings" {
  type = object({
    auto_create_topics_enable = optional(bool)
    bootstrap_servers         = optional(string)
    log_retention_hours       = optional(number)
    num_partitions            = optional(number)
  })
  default = null
}

variable "name" {
  type = string
}

variable "private_endpoint_settings" {
  type = object({
    nsg_ids             = optional(list(string))
    private_endpoint_ip = optional(string)
    subnet_id           = optional(string)
  })
  default = null
}

variable "stream" {
  type = list(object({
    name               = string
    partitions         = number
    retention_in_hours = optional(number)
  }))
  default = null
}

variable "groups" {
  type    = list(string)
  default = []
}

# service account vars
variable "root_compartment_id" {
  type    = string
  default = null
}

variable "service_account_description" {
  type    = string
  default = null
}

variable "service_account_name" {
  type    = string
  default = null
}

variable "group_description" {
  type    = string
  default = null
}

variable "group_name" {
  type    = string
  default = null
}