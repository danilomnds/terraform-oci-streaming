resource "oci_streaming_stream_pool" "stream_pool" {
  compartment_id = var.compartment_id
  dynamic "custom_encryption_key" {
    for_each = var.custom_encryption_key != null ? [var.custom_encryption_key] : []
    content {
      kms_key_id = lookup(custom_encryption_key.value, "kms_key_id", null)
    }
  }
  defined_tags  = local.defined_tags
  freeform_tags = var.freeform_tags
  dynamic "kafka_settings" {
    for_each = var.kafka_settings != null ? [var.kafka_settings] : []
    content {
      auto_create_topics_enable = lookup(kafka_settings.value, "auto_create_topics_enable", null)
      bootstrap_servers         = lookup(kafka_settings.value, "bootstrap_servers", null)
      log_retention_hours       = lookup(kafka_settings.value, "log_retention_hours", null)
      num_partitions            = lookup(kafka_settings.value, "num_partitions", null)
    }
  }
  name = var.name
  dynamic "private_endpoint_settings" {
    for_each = var.private_endpoint_settings != null ? [var.private_endpoint_settings] : []
    content {
      nsg_ids             = lookup(private_endpoint_settings.value, "nsg_ids", null)
      private_endpoint_ip = lookup(private_endpoint_settings.value, "private_endpoint_ip", null)
      subnet_id           = lookup(private_endpoint_settings.value, "subnet_id", null)
    }
  }
  lifecycle {
    ignore_changes = [
      defined_tags["IT.create_date"]
    ]
  }
  timeouts {
    create = "12h"
    delete = "6h"
  }
}

resource "oci_streaming_stream" "stream" {
  depends_on         = [oci_streaming_stream_pool.stream_pool]
  for_each           = var.stream != null ? { for k, v in var.stream : k => v if v != null } : {}  
  defined_tags       = local.defined_tags
  freeform_tags      = var.freeform_tags
  stream_pool_id     = oci_streaming_stream_pool.stream_pool.id
  name               = each.value.name
  partitions         = each.value.partitions
  retention_in_hours = lookup(each.value, "retention_in_hours", 24)
  lifecycle {
    ignore_changes = [
      defined_tags["IT.create_date"]
    ]
  }
  timeouts {
    create = "12h"
    delete = "6h"
  }
}

resource "oci_identity_policy" "stream_pool_policy" {
  #if you are deploying the resource outside your home region uncomment the line below
  #provider   = oci.home-region
  depends_on = [oci_streaming_stream_pool.stream_pool]
  for_each = {
    for group in var.groups : group => group
    if var.groups != []
  }
  compartment_id = var.compartment_id
  name           = "policy_${var.name}"
  description    = "allow one or more groups to read the streaming pool and streams and also publish and consume messages"
  statements = [
    "Allow group ${each.value} to read stream-pools in compartment id ${var.compartment_id}",
    "Allow group ${each.value} to read streams in compartment id ${var.compartment_id}",
    "Allow group ${each.value} to use stream-push in compartment id ${var.compartment_id}",
    "Allow group ${each.value} to use stream-pull in compartment id ${var.compartment_id}"
  ]
}