output "stream_pool_id" {
  value = oci_streaming_stream_pool.stream_pool.id
}

output "stream_id" {
  description = "stream id"
  value       = [for stream in oci_streaming_stream.stream : stream.id]
}