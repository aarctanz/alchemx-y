output "gateway_public_ip" {
  description = "Public IP of the gateway — the API front door."
  value       = google_compute_instance.gateway.network_interface[0].access_config[0].nat_ip
}

output "gateway_internal_ip" {
  description = "Internal IP workers use for III_URL."
  value       = google_compute_address.gateway-internal.address
}
