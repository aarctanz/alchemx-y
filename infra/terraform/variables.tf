variable "project_id" {
  type        = string
  description = "GCP project to deploy into."
}

variable "region" {
  type        = string
  default     = "asia-south2"
  description = "GCP region to deploy into."
}

variable "zone" {
  type        = string
  default     = "asia-south2-a"
  description = "GCP zone to deploy into."
}
